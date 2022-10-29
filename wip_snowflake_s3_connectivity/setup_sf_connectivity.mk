all: get_snowflake_vpcid update_s3_bucket_policies create_tmp_snowflake_iam_role create_sf_storage_int_obj create_snowflake_iam_role

# fetch inputs from config (json) file
CONFIG_FILE=env/env_example.json
#$(eval [VAR_NAME]=$(shell jq '.Parameters.[VAR_NAME]' ${CONFIG_FILE}))
$(eval PROGRAM=$(shell jq '.Parameters.Program' ${CONFIG_FILE}))
$(eval PROGRAM_LOWER = $(shell echo $(PROGRAM) | tr 'A-Z' 'a-z'))
$(eval PROGRAM_UPPER = $(shell echo $(PROGRAM) | tr 'a-z' 'A-Z'))
$(eval ENV=$(shell jq '.Parameters.Environment' ${CONFIG_FILE}))
$(eval ENV_UPPER=$(shell jq '.Parameters.Environment' ${CONFIG_FILE}))
$(eval AWS_PROFILE=$(shell jq '.Parameters.AWSParameters.AwsProfile' ${CONFIG_FILE}))
$(eval AWS_ACCOUNT_ID=$(shell jq '.Parameters.AWSParameters.AwsAccountId' ${CONFIG_FILE}))
$(eval SNOWFLAKE_CONN_PROFILE=$(shell jq '.Parameters.SnowflakeParameters.SnowflakeConnectionProfile' ${CONFIG_FILE}))
$(eval SNOWFLAKE_ACCOUNT_NAME=$(shell jq '.Parameters.SnowflakeParameters.SnowflakeAccountName' ${CONFIG_FILE} | tr 'a-z' 'A-Z'))
$(eval SNOWFLAKE_DBA_USER=$(shell jq '.Parameters.SnowflakeParameters.SnowflakeIAMRoleName' ${CONFIG_FILE}))
$(eval SNOWFLAKE_IAM_ROLE_NAME=$(shell jq '.Parameters.SnowflakeParameters.SnowflakeIAMRoleName' ${CONFIG_FILE}))
$(eval SNOWFLAKE_VPCID=$(shell jq '.Parameters.SnowflakeParameters.SnowflakeVPCID' ${CONFIG_FILE}))
$(eval S3_BUCKET_EG=$(shell jq '.Parameters.AdditionalParameters.S3BucketEg' ${CONFIG_FILE}))
#configure S3_BUCKET_LIST as required. If multiple buckets are required, then list them using a comma delimiter, e.g.:
#S3_BUCKET_LIST='s3://${S3_BUCKET_EG},s3://${S3_BUCKET_EG2}'
S3_BUCKET_LIST='s3://${S3_BUCKET_EG}'
#standardised Snowflake SnowSQL query format / options
SNOWSQL_QUERY=snowsql -c ${SNOWFLAKE_CONN_PROFILE} -o friendly=false -o header=false -o timing=false

deps:
	$(info [+] Install dependencies (snowsql))
	# need to source your bash_profile, post-install
	brew cask install snowflake-snowsql && . ~/.bash_profile

get_snowflake_vpcid:
	$(info [+] Get Snowflake's VPCID)
	@[ "${SNOWFLAKE_CONN_PROFILE}" ] || ( echo "\nError: SNOWFLAKE_CONN_PROFILE variable is not set\n"; exit 1 )
	@${SNOWSQL_QUERY} -q 'SELECT system$$get_snowflake_platform_info();' -r accountadmin > op/stg/snowflake-query-op/snowflake-vpcid.txt

update_s3_bucket_policies:
	$(info [+] Change S3 bucket policies, to allow communication from Snowflake's VPC ID)
	@$(eval VPCID=$(shell python3 py/parse_snowflake_op.py get_snowflake_vpcid ${SNOWFLAKE_ACCOUNT_NAME}))
	@[ "${AWS_PROFILE}" ] || ( echo "\nError: AWS_PROFILE variable is not set\n"; exit 1 )
	@[ "${SNOWFLAKE_VPCID}" ] || ( echo "\nError: SNOWFLAKE_VPCID variable is not set\n"; exit 1 )
	@aws cloudformation create-stack \
	--profile ${AWS_PROFILE} \
	--stack-name ${PROGRAM}-s3-bucket-policy-update-for-snowflake \
	--template-body file://aws/cfn/s3/bucket-policy/s3-bucket-policy-snowflake.yml \
	--parameters ParameterKey=S3BucketName,ParameterValue=${S3_BUCKET_EG} \
	ParameterKey=VPCID,ParameterValue=$(SNOWFLAKE_VPCID) \

create_tmp_snowflake_iam_role:
	$(info [+] Create a tmp Snowflake IAM role, to allow a SF storage int object to be initially created)
	@[ "${AWS_PROFILE}" ] || ( echo "\nError: AWS_PROFILE variable is not set\n"; exit 1 )
	#1) Create a temporary Snowflake IAM role
	@aws cloudformation create-stack \
	--profile ${AWS_PROFILE} \
	--stack-name ${PROGRAM_LOWER}-iam-role-tmp-snowflake-access \
	--capabilities ${CAPABILITIES} \
	--template-body file://aws/cfn/iam/tmp/snowflake-tmp-iam-role.yml \
	--parameters ParameterKey=IAMRoleName,ParameterValue=tmp-${SNOWFLAKE_IAM_ROLE_NAME} \
	ParameterKey=TrustedAccountID,ParameterValue=${AWS_ACCOUNT_ID}

create_sf_storage_int_obj:
	$(info [+] Create the Snowflake storage int object)
	@[ "${SNOWFLAKE_CONN_PROFILE}" ] || ( echo "\nError: SNOWFLAKE_CONN_PROFILE variable is not set\n"; exit 1 )
	#1) Create a storage integration object
	@${SNOWSQL_QUERY} -o quiet=true -f sql/dwh/account-objects/storage-integration/v1-create-s3-storage-integration.sql -D PROGRAM=${PROGRAM} -D ENV=${ENV} -D IAMROLENAME=${SNOWFLAKE_IAM_ROLE_NAME} -D AWS_ACCOUNT_ID=${AWS_ACCOUNT_ID} -D ALLOWED_S3_LOCATIONS="${BUCKET_LIST}"
	#2) Grant usage permissions of Storage Integration object to '{PROGRAM}_{ENV}_SI_ADMIN' (storage integration admin)
	@${SNOWSQL_QUERY} -o quiet=true -f sql/dwh/account-objects/role/v1-create-role-sf-si-admin.sql -D PROGRAM=${PROGRAM} -D ENV=${ENV}
	@${SNOWSQL_QUERY} -o quiet=true -f sql/dwh/account-objects/role/permissions/v1-grant-perms-to-sf-si-admin-role.sql -D PROGRAM=${PROGRAM} -D ENV=${ENV}
	#3) Capture the snowsql query op
	@${SNOWSQL_QUERY} -q "desc integration ${PROGRAM}_${ENV}_S3_INT;" -r accountadmin > op/stg/snowflake-query-op/snowflake-iam-user.txt

create_snowflake_iam_role:
	$(info [+] Create the finalised Snowflake IAM role, used to allow comms between AWS and Snowflake)
	@[ "${AWS_PROFILE}" ] || ( echo "\nError: AWS_PROFILE variable is not set\n"; exit 1 )
	#1) assign vars to the snowsql query op
	$(eval SNOWFLAKE_IAM_USER_ARN=$(shell python3 py/parse_snowflake_op.py get_snowflake_iam_user_arn ${SNOWFLAKE_ACCOUNT_NAME}))
	$(eval SNOWFLAKE_EXT_ID=$(shell python3 py/parse_snowflake_op.py get_ext_id ${SNOWFLAKE_ACCOUNT_NAME}))
	@echo
	@echo "SNOWFLAKE_IAM_USER_ARN = ${SNOWFLAKE_IAM_USER_ARN}"
	@echo "SNOWFLAKE_EXT_ID = ${SNOWFLAKE_EXT_ID}"
	@echo
	@aws cloudformation create-stack \
	--profile ${AWS_PROFILE} \
	--stack-name ${PROGRAM_LOWER}-iam-role-snowflake-access \
	--capabilities ${CAPABILITIES} \
	--template-body file://aws/cfn/iam/snowflake-iam-role.yml \
	--parameters ParameterKey=IAMRoleName,ParameterValue=${SNOWFLAKE_IAM_ROLE_NAME} \
	ParameterKey=SnowflakeUserARN,ParameterValue=${SNOWFLAKE_IAM_USER_ARN} \
	ParameterKey=SnowflakeExternalID,ParameterValue=${SNOWFLAKE_EXT_ID}

	#2) Then delete the stack of the temporary snowflake IAM role
	#@aws cloudformation delete-stack --stack-name ${PROGRAM_LOWER}-iam-role-tmp-snowflake-access --profile ${AWS_PROFILE}

del_cfn_stacks:
	$(info [+] Quickly delete cfn templates)
	@[ "${AWS_PROFILE}" ] || ( echo "\nError: AWS_PROFILE variable is not set\n"; exit 1 )
	rm -r op/stg/snowflake-query-op/
	@aws cloudformation delete-stack --stack-name ${PROGRAM}-iam-role-snowflake-access --profile ${AWS_PROFILE}
	@aws cloudformation delete-stack --stack-name ${PROGRAM}-iam-role-tmp-snowflake-access --profile ${AWS_PROFILE}

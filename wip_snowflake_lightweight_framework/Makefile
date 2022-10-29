all: create_snowflake_account_objs establish_sf_s3_connectivity create_snowflake_raw_db_objs create_snowflake_curated_db_objs create_snowflake_analytics_db_objs

config_file=envvars.json

$(eval program=$(shell jq '.Parameters.program' ${config_file}))
$(eval program_upper=$(shell echo $(program) | tr 'a-z' 'A-Z'))
$(eval program_lower=$(shell echo $(program) | tr 'A-Z' 'a-z'))
$(eval env=$(shell jq '.Parameters.Environment' ${config_file}))
$(eval env_upper=$(shell jq '.Parameters.Environment' ${config_file}))
$(eval data_src1=$(shell jq '.Parameters.data_src1' ${config_file}))
$(eval data_src2=$(shell jq '.Parameters.data_src2' ${config_file}))
$(eval dba_user=$(shell jq '.Parameters.EgDBAUser' ${config_file}))
$(eval sf_conn_profile=$(shell echo $(program) | tr 'A-Z' 'a-z'))
$(eval bootstrap_version=$(shell jq '.Parameters.snowsql_bootstrap_version' ${config_file}))
$(eval snowsql_version=$(shell jq '.Parameters.snowsql_version' ${config_file}))
$(eval snowsql_installer_path=$(shell jq '.Parameters.snowsql_installer_path' ${config_file}))
$(eval sf_acc_name=$(shell jq '.Parameters.SnowflakeParams.sf_acc_name' ${config_file}))
$(eval sf_username=$(shell jq '.Parameters.SnowflakeParams.sf_username' ${config_file}))
$(eval sf_pass=$(shell jq '.Parameters.SnowflakeParams.sf_pass' ${config_file}))
$(eval aws_account_id=$(shell jq '.Parameters.AdditionalParameters.AwsAccountId' ${config_file}))
$(eval sf_iam_role_name=$(shell jq '.Parameters.AdditionalParameters.SnowflakeIAMRoleName' ${config_file}))
$(eval s3_bucket_eg=$(shell jq '.Parameters.AdditionalParameters.S3BucketEg' ${config_file}))
# configure s3_bucket_kust as required. If multiple buckets are required, then list them using a comma delimiter, e.g.: S3_BUCKET_LIST='s3://${S3_BUCKET_EG},s3://${S3_BUCKET_EG2}'
s3_bucket_list='s3://${s3_bucket_eg}'
# standardised Snowflake SnowSQL query format / options
snowsql_query=snowsql -c ${sf_conn_profile} -o friendly=false -o header=false -o timing=false

installations: deps install clean

deps:
	$(info [+] Download the relevant dependencies)
	# download SnowSQL
	@cd tmp && curl ${snowsql_installer_path} > snowsql-darwin_x86_64.pkg

install:
	$(info [+] Install the relevant dependencies)
	# install SnowSQL
	# @cd tmp && installer -pkg snowsql-darwin_x86_64.pkg -target CurrentUserHomeDirectory
	# optional (for .z-shell only: add an alias to snowsql to your profile)
	# @echo "alias snowsql=~/Applications/SnowSQL.app/Contents/MacOS/snowsql" >> ~/.zshrc && source ~/.zshrc
	# Create a Snowflake connection profile
	@sed "s/%program/${program_lower}/g" ip/conn_profile_template.txt > tmp/conn_profile.txt
	@sed -i -e "s/%sf_acc_name/${sf_acc_name}/g" tmp/conn_profile.txt
	@sed -i -e "s/%sf_username/${sf_username}/g" tmp/conn_profile.txt
	@sed -i -e "s/%sf_pass/${sf_pass}/g" tmp/conn_profile.txt
	@cat tmp/conn_profile.txt >> ~/.snowsql/config
	# test the snowsql 'named connection' query
	${snowsql_query}

clean:
	$(info [+] Remove any redundant files, e.g. downloads)
	@rm tmp/*.pkg
	@rm tmp/conn_profile.txt-e

create_snowflake_account_objs:
	$(info [+] Create the snowflake account objects)
	@[ "${sf_conn_profile}" ] || ( echo "\nError: sf_conn_profile variable is not set\n"; exit 1 )
	# set the default timezone and timestamp values
	@${snowsql_query} -f set_default_tz_and_ts.sql
	@${snowsql_query} -f account_objects/role/v1_roles.sql --variable program=${program} --variable env=${env}
	# note: part of the script below may not be needed right away. The main purpose of this script is to grant privs to the user 'SNOWFLAKE_PIPELINE_DEPLOYMENT_USER' & any developer users on the project
	@${snowsql_query} -f account_objects/role/permissions/grant_permissions/v1_grant_dba_role.sql --variable program=${program} --variable env=${env} --variable dba_user=${dba_user}
	@${snowsql_query} -f account_objects/role/permissions/grant_permissions/create/v1_grant_create_db_and_wh_perms.sql --variable program=${program} --variable env=${env}
	@${snowsql_query} -f account_objects/resource_monitor/v1_resource_monitors.sql --variable program=${program} --variable env=${env}
	@${snowsql_query} -f account_objects/role/permissions/grant_permissions/ownership/v1_grant_resource_monitor_ownership_perms.sql --variable program=${program} --variable env=${env}
	@${snowsql_query} -f account_objects/warehouse/v1_warehouses.sql --variable program=${program} --variable env=${env}
	@${snowsql_query} -f account_objects/role/permissions/grant_permissions/ownership/v1_grant_wh_ownership_perms.sql --variable program=${program} --variable env=${env}
	@${snowsql_query} -f account_objects/database/v1_raw_db_and_schemas.sql --variable program=${program} --variable env=${env} --variable data_src1=${data_src1} --variable data_src2=${data_src2}
	@${snowsql_query} -f account_objects/database/v1_curated_db_and_schemas.sql --variable program=${program} --variable env=${env}
	@${snowsql_query} -f account_objects/database/v1_analytics_db_and_schemas.sql --variable program=${program} --variable env=${env} --variable data_src=${data_src1}
	@${snowsql_query} -f account_objects/role/permissions/grant_permissions/v1_grant_execute_task_perms.sql --variable program=${program} --variable env=${env}
	# @${snowsql_query} -f account_objects/role/permissions/grant_permissions/v1_grant_apply_tag_permissions.sql --variable program=${program} --variable env=${env}
	@${snowsql_query} -f account_objects/role/permissions/grant_permissions/create/v1_grant_create_stage_perms.sql --variable program=${program} --variable env=${env}
	@${snowsql_query} -f account_objects/role/permissions/v1_create_role_hierarchy.sql --variable program=${program} --variable env=${env}
	# the 3 objects below require a subsequent AWS IAM role to be created (see the Makefile target 'establish_sf_s3_connectivity' below)
	# @${snowsql_query} -f account_objects/storage_integration/v1-create-s3-storage-integration.sql --variable program=${program} --variable env=${env} --variable env=${env} --variable IAMROLENAME=${sf_iam_role_name} --variable aws_account_id=${aws_account_id} --variable ALLOWED_S3_LOCATIONS="${S3_BUCKET_LIST}"
	# @${snowsql_query} -f account_objects/role/permissions/grant_permissions/ownership/v1_grant_storage_int_ownership_perms.sql --variable program=${program} --variable env=${env}
	@${snowsql_query} -f account_objects/role/permissions/grant_permissions/v1_grant_role_permissions.sql --variable program=${program} --variable env=${env}

establish_sf_s3_connectivity:
	$(info [+] Establish connectivity between specified S3 buckets and Snowflake)
	@[ "${sf_conn_profile}" ] || ( echo "\nError: sf_conn_profile variable is not set\n"; exit 1 )
	cd ../build/snowflake-s3-connectivity/ && make -f setup_sf_connectivity.mk update_s3_bucket_policies config_file=${config_file}
	cd ../build/snowflake-s3-connectivity/ && make -f setup_sf_connectivity.mk create_tmp_snowflake_iam_role config_file=${config_file}
	cd ../build/snowflake-s3-connectivity/ && make -f setup_sf_connectivity.mk create_sf_storage_int_obj config_file=${config_file}
	cd ../build/snowflake-s3-connectivity/ && make -f setup_sf_connectivity.mk create_snowflake_iam_role config_file=${config_file}

create_snowflake_raw_db_objs:
	$(info [+] Create the snowflake RAW db objects)
	@$(eval PROGRAM_LOWER = $(shell echo $(program) | tr 'A-Z' 'a-z'))
	@[ "${sf_conn_profile}" ] || ( echo "\nError: sf_conn_profile variable is not set\n"; exit 1 )
	${snowsql_query} -f database_objects/raw_db/file_format/v1_parquet_file_format.sql --variable program=${program} --variable env=${env}
	${snowsql_query} -f database_objects/raw_db/file_format/v1_csv_file_format.sql --variable program=${program} --variable env=${env}
	#${snowsql_query} -f database_objects/raw_db/stage/v1_eg_stage.sql --variable program=${program_upper} --variable env=${env_upper} --variable S3_BUCKET_PATH=${s3_bucket_eg}
	#${snowsql_query} -f database_objects/raw_db/ext_table/v1_<DATA_SRC>_ext_tbl.sql --variable program=${program} --variable env=${env}
	${snowsql_query} -f database_objects/raw_db/table/v1_etl_control_tbl.sql --variable program=${program} --variable env=${env} --variable data_src=${data_src1}
	#${snowsql_query} -f database_objects/raw_db/table/<DATA_SRC>/<TBL_TO_LOAD>.sql --variable program=${program} --variable env=${env}
	#${snowsql_query} -f database_objects/raw_db/task/v1_<DATA_SRC>_tsk.sql --variable program=${program} --variable env=${env}

create_snowflake_curated_db_objs:
	$(info [+] Create the snowflake curated db objects)
	@[ "${sf_conn_profile}" ] || ( echo "\nError: sf_conn_profile variable is not set\n"; exit 1 )
	${snowsql_query} -f database_objects/curated_db/view/${DATA MODEL OBJS}.sql --variable program=${program} --variable env=${env}

create_snowflake_analytics_db_objs:
	$(info [+] Create the snowflake analytics db objects)
	@[ "${sf_conn_profile}" ] || ( echo "\nError: sf_conn_profile variable is not set\n"; exit 1 )
	${snowsql_query} -f database_objects/analytics_db/view/${REPORTING LAYER OBJS}.sql --variable program=${program} --variable env=${env}

################################################################################################################################################
# smaller example
################################################################################################################################################
create_and_upload_raw_db_obj_data:
	$(info [+] Create the snowflake RAW db objects)
	@${snowsql_query} -f database_objects/raw_db/table/v1_sales_tbls.sql --variable program=${program} --variable env=${env}
	@${snowsql_query} -f database_objects/raw_db/table/v1_production_tbls.sql --variable program=${program} --variable env=${env}

load_ip_data:
	$(info [+] Create stages, upload files to stage then load into target tables)
	@${snowsql_query} -f database_objects/raw_db/file_format/v1_csv_file_format.sql --variable PROGRAM=${program} --variable env=${env}
	@${snowsql_query} -f database_objects/raw_db/stage/v1_bikestores_stage.sql --variable PROGRAM=${program_upper} --variable env=${env}

	# upload the files
	@${snowsql_query} -f data_loading/upload_data.sql --variable PROGRAM=${program} --variable env=${env}
	@${snowsql_query} -f data_loading/insert_data_into_raw_production_tbls.sql --variable PROGRAM=${program} --variable env=${env}
	@${snowsql_query} -f data_loading/insert_data_into_raw_sales_tbls.sql --variable PROGRAM=${program} --variable env=${env}

################################################################################################################################################
# Dev scripts
################################################################################################################################################
drop_sf_db_objs:
	$(info [+] Dev purposes: quickly drop all raw/curated/analytics DB objs)
	${snowsql_query} -f dev_scripts/drop_db_objs_struct.sql --variable program=${program} --variable env=${env_upper}

dev_skelton_structure:
	${snowsql_query} -f dev_scripts/dev_sf_db_struct/drop_dbs.sql --variable env=${env_upper}
	${snowsql_query} -f dev_scripts/dev_sf_db_struct/create_dev_dbs.sql --variable env=${env_upper}
	${snowsql_query} -f dev_scripts/dev_sf_db_struct/grant_perms.sql --variable env=${env_upper}
	${snowsql_query} -f dev_scripts/dev_sf_db_struct/create_db_objs.sql --variable env=${env_upper}

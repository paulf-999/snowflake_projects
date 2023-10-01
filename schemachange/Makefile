SHELL = /bin/sh
#================================================================
# Usage
#================================================================
# make installations	# install the package for the first time, managing dependencies & also perform housekeeping tasks
# make deps		# just install the dependencies
# make install		# perform the end-to-end install
# make clean		# perform a housekeeping cleanup

#=======================================================================
# Variables
#=======================================================================
.EXPORT_ALL_VARIABLES:

# Load environment variables from .env file
include .env

# load variables from separate file
include config.mk

#=======================================================================
# Targets
#=======================================================================
all: deps install clean

deps:
	@echo "----------------------------------------------------------------------------------------------------------------------"
	@echo "${YELLOW}Target: 'deps'. Download the relevant pip package dependencies.${COLOUR_OFF}"
	@echo "----------------------------------------------------------------------------------------------------------------------" && echo
	@echo "Install the prerequisite Python libraries (see requirements.txt)" && echo
	@pip3 install --disable-pip-version-check -r requirements.txt -q
	@echo "create the required Snowflake user 'SVC_USER' and role 'CICD_ALL_ROLE'" && echo
	@make create_svc_cicd_user_and_role
	@echo "Create the the required Snowflake `change_history` table" && echo

install:
	@echo "------------------------------------------------------------------"
	@echo "${YELLOW}Target: 'install'. Run the setup and install targets.${COLOUR_OFF}"
	@echo "------------------------------------------------------------------"

test:
	@echo "------------------------------------------------------------------"
	@echo "${YELLOW}Target 'test'. Perform any required tests.${COLOUR_OFF}"
	@echo "------------------------------------------------------------------"

clean:
	@echo "------------------------------------------------------------------"
	@echo "${YELLOW}Target 'clean'. Remove any redundant files, e.g. downloads.${COLOUR_OFF}"
	@echo "------------------------------------------------------------------" && echo
	@echo "Facilitate dev-work: blow away any Snowflake objects created for the user/role 'SVC_CICD' & 'CICD_ALL_ROLE'"
	@echo
	@python3 src/py/snowflake_client/snowflake_client.py --sql-file src/sql/setup_user_svc_cicd/dev_script.sql && echo

#-----------------------------
# Supplementary scripts
#------------------------------
gen_env_template:
	@echo && echo "Generate the template .env file"
	@j2 src/jinja_templates/.env_template.j2 -o .env

create_svc_cicd_user_and_role: get_ips
	@echo "1. Create the Snowflake CICD service account user 'SVC_CICD'"
	@python3 src/py/snowflake_client/snowflake_client.py --sql-file src/sql/setup_user_svc_cicd/1_create_user_svc_cicd.sql && echo
	@echo "2. Create the Snowflake CICD role, 'CICD_ALL_ROLE'"
	@python3 src/py/snowflake_client/snowflake_client.py --sql-file src/sql/setup_user_svc_cicd/2_create_role_cicd_all_role.sql && echo
	@echo "3. Grant the role 'CICD_ALL_ROLE' to the user 'SVC_CICD'"
	@python3 src/py/snowflake_client/snowflake_client.py --sql-file src/sql/setup_user_svc_cicd/3_grant_role_cicd_all_role_to_user_svc_cicd.sql && echo
	@echo "4. Change the ownership of the new user and role"
	@python3 src/py/snowflake_client/snowflake_client.py --sql-file src/sql/setup_user_svc_cicd/4_grant_ownership_cicd_user_and_role.sql && echo
	@echo "5. Grant the required permissions to the role 'CICD_ALL_ROLE'"
	@python3 src/py/snowflake_client/snowflake_client.py --sql-file src/sql/setup_user_svc_cicd/5_grant_permissions_to_role_cicd_all_role.sql --args-json '{"database": "${SNOWFLAKE_CHANGE_HISTORY_DB}"}' && echo
	@echo "Finished! Snowflake user 'SVC_CICD' and role 'CICD_ALL_ROLE' created with the required permissions."

get_ips:
	@# Target: 'get_ips'. Check if the environment variable is defined
    ifndef SNOWFLAKE_CHANGE_HISTORY_DB
        $(error SNOWFLAKE_CHANGE_HISTORY_DB is not defined. Please set it before running this target.)
    endif
    ifndef SNOWFLAKE_CHANGE_HISTORY_DB_SCHEMA
        $(error SNOWFLAKE_CHANGE_HISTORY_DB_SCHEMA is not defined. Please set it before running this target.)
    endif

demo:
	git mv V0.0.0__roles.sql V0.0.4__roles.sql
	# add my 'create role' code to V0.0.4__roles.sql
	git add V0.0.4__roles.sql
	git commit -m "cicd for Snowflake objs demo: new role"
	git push -u origin feature/eg_version_control_sf_objs

# Phony targets
.PHONY: all deps install test clean

# .PHONY tells Make that these targets don't represent files
# This prevents conflicts with any files named "all" or "clean"

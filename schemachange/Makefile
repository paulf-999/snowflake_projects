# Usage:
# make deps							# install the dependencies

.EXPORT_ALL_VARIABLES:
#=======================================================================
# Variables
#=======================================================================
# Colour formatting variables
YELLOW := \033[0;33m
COLOUR_OFF := \033[0m

# TODO (housekeeping)
SF_ACCOUNT :=
SF_USERNAME :=
SF_ROLE := SYSADMIN
SF_WH :=
SF_DB :=

deps:
	@echo "----------------------------------------------------------------------------------------------------------------------"
	@echo "${YELLOW}Target: 'deps'. Download the relevant Ubuntu/pip package dependencies.${COLOUR_OFF}"
	@echo "----------------------------------------------------------------------------------------------------------------------"
	pip3 install --disable-pip-version-check -r requirements.txt -q

setup:
	@echo "----------------------------------------------------------------------------------------------------------------------"
	@echo "${YELLOW}Target: 'setup'. Setup schemachange.${COLOUR_OFF}"
	@echo "----------------------------------------------------------------------------------------------------------------------"
	# done
	CREATE DATABASE IF NOT EXISTS PF_POC_SCHEMACHANGE_DB;

create_history_tbl:
	schemachange -f schemachange \
		-a ${SF_ACCOUNT} \
		-u ${SF_USERNAME} \
		-r ${SF_ROLE} \
		-w ${SF_WH} \
		-d ${SF_DB} \
		-c ${SF_DB}.SCHEMACHANGE.CHANGE_HISTORY \
		--create-change-history-table

wip_steps:
	sh ../../../src/sh/create_directories.sh
	# reference tmp/current_version.txt

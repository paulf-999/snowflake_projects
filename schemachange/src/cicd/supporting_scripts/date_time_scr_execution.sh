#!/bin/bash

# read in shared variables from a separate shell script (better code readability)
source dmt-scripts-snowflake/src/cicd/supporting_scripts/common_vars_cicd_scripts.sh

echo -e "${PURPLE}#----------------------------------------------------------"
echo -e "${PURPLE}# Date/time of execution"
echo -e "${PURPLE}#----------------------------------------------------------"
echo -e "${PURPLE}# Date: $(date +"%a %d %B %Y")"
echo -e "${PURPLE}# Time: $(date +"%H:%M %p")"
echo -e "${PURPLE}#----------------------------------------------------------" && echo

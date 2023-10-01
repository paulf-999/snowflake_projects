#!/bin/bash
#=======================================================================
# Variables
#=======================================================================

# read in shared variables from a separate shell script (better code readability)
source dmt-scripts-snowflake/src/cicd/supporting_scripts/common_vars_cicd_scripts.sh

#=======================================================================
# Main script logic
#=======================================================================

# read in script to output date/time of script execution
source dmt-scripts-snowflake/src/cicd/supporting_scripts/date_time_scr_execution.sh

rm -rf /usr/local/lib/python3.8/dist-packages/OpenSSL && rm -rf /usr/local/lib/python3.8/dist-packages/pyOpenSSL-22.1.0.dist-info/
pip install --upgrade pyOpenSSL -q
pip install -r dmt-scripts-snowflake/src/cicd/supporting_scripts/requirements.txt -q

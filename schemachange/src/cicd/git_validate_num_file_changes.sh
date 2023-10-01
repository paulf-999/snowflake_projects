#!/bin/bash
#=======================================================================
# Variables
#=======================================================================

# read in shared variables from a separate shell script (better code readability)
source dmt-scripts-snowflake/src/cicd/supporting_scripts/common_vars_cicd_scripts.sh

PR_BRANCH=origin/${1}
BASE_BRANCH=origin/develop
MAX_FILES_CHANGED=20

#=======================================================================
# Main script logic
#=======================================================================

# read in script to output date/time of script execution
source dmt-scripts-snowflake/src/cicd/supporting_scripts/date_time_scr_execution.sh

echo -e "${YELLOW}# Step 1: Checkout to the feature branch"
git checkout -q "${PR_BRANCH}"

echo -e "${YELLOW}# Step 2: Count the number of changed files between the two branches"
echo -e "${YELLOW}# Command: git diff --name-only --diff-filter=ADMR $BASE_BRANCH..$PR_BRANCH | sort -u | wc -l" && echo
# 'diff-filter=ADMR' means the following:
# A = added files
# D = deleted files
# M = modified files
# R = renamed files
FILE_COUNT=$(git diff --name-only --diff-filter=ADMR $BASE_BRANCH.."$PR_BRANCH" | sort -u | wc -l)

if [ "${FILE_COUNT}" -gt ${MAX_FILES_CHANGED} ]; then
    echo && echo -e "${RED}#--------------------------------------------------------------------------------------------"
    echo -e "${RED}# Error: Number of files changed in PR (${FILE_COUNT}) exceeds the max (${MAX_FILES_CHANGED})."
    echo -e "${RED}#--------------------------------------------------------------------------------------------" && echo
    exit 1
else
    echo "Number of files changed: ${FILE_COUNT}" && echo
    echo -e "${GREEN}SUCCESS: Number of changed files is less than the max (${MAX_FILES_CHANGED})."
fi

#!/bin/bash
#=======================================================================
# Variables
#=======================================================================

# read in shared variables from a separate shell script (better code readability)
source dmt-scripts-snowflake/src/cicd/supporting_scripts/common_vars_cicd_scripts.sh

# the regex for valid git branch names
VALID_GIT_BRANCH_NAME="^(feature|hotfix|release)\/[a-z0-9_]+$"

#=======================================================================
# Main script logic
#=======================================================================
# read in script to output date/time of script execution
source dmt-scripts-snowflake/src/cicd/supporting_scripts/date_time_scr_execution.sh

echo -e "${YELLOW}# Step 1: Let's make sure we're on our FEATURE branch"
echo -e "${YELLOW}# Command: git checkout origin/${SOURCE_GIT_BRANCH_NAME}"
git checkout origin/"${SOURCE_GIT_BRANCH_NAME}" -q && echo

# Validate the Git branch name used
echo -e "${YELLOW}# Step 2: Let's validate the Git branch name, for the feature branch"
echo -e "${YELLOW}# Command: if [[ ! $SOURCE_GIT_BRANCH_NAME =~ $VALID_GIT_BRANCH_NAME ]]" && echo
if [[ ! $SOURCE_GIT_BRANCH_NAME =~ $VALID_GIT_BRANCH_NAME ]]
then
    echo
    echo -e "${RED}#############################################################################################"
    echo -e "${RED}# ERROR: Invalid Git branch name."
    echo -e "${RED}#############################################################################################${COLOUR_OFF}"
    echo -e "Local git branch name = $SOURCE_GIT_BRANCH_NAME"
    echo
    echo -e "Git branch name needs to adhere to the following regex: $VALID_GIT_BRANCH_NAME."
    echo
    echo -e "I.e., it needs to:"
    echo
    echo -e "* Start with either 'feature/', 'hotfix/' or 'release/'"
    echo -e "* Followed by a snake_case description of your change (note, hyphens aren't allowed)."
    echo
    echo -e "E.g.: feature/my_eg_change"
    echo
    exit 1
else
    echo -e "${GREEN}SUCCESS: Valid Git branch name" && echo
fi

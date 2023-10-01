#!/bin/bash
#=======================================================================
# Variables
#=======================================================================

# Path to the inpur file
IP_FILE_PATH="dmt-scripts-snowflake/schemachange/_current_version.txt"

# read in script to output date/time of script execution
source dmt-scripts-snowflake/src/cicd/supporting_scripts/date_time_scr_execution.sh

#=======================================================================
# Functions
#=======================================================================
# function to get the latest/largest version number of the changed files
get_latest_changed_file_version() {
    local CURRENT_VERSION="$1" # Input parameter: CURRENT_VERSION
    MAX_VERSION="0.0.0" # Initialize the maximum version with a default minimum version

    # Get the list of changed files
    CHANGED_FILES=$(cd dmt-scripts-snowflake && git diff --name-only --diff-filter=ADMR origin/"$TARGET_GIT_BRANCH_NAME"..origin/"$SOURCE_GIT_BRANCH_NAME" | sort -u)
    # Iterate through the changed files to find the maximum version
    for FILE in $CHANGED_FILES; do
        # Check if the value of FILE starts with 'schemachange/'
        if [[ "$FILE" == "schemachange/"*".sql" ]]; then
            # Use awk to extract the version part of the SQL filename
            EXTRACTED_PART=$(echo "$FILE" | awk -F '/' '{gsub(/^.*V|__.*\.sql$/,"",$NF); print $NF}')

            # Compare the current extracted version with the maximum version found so far
            if [ "$EXTRACTED_PART" \> "$MAX_VERSION" ]; then
                MAX_VERSION="$EXTRACTED_PART"
            fi
        fi
    done

    # Check if MAX_VERSION is still the default value
    if [ "$MAX_VERSION" = "0.0.0" ] || [ -z "$MAX_VERSION" ]; then
        MAX_VERSION=$CURRENT_VERSION
    fi

    # Return the maximum version
    echo "$MAX_VERSION"
}

# Function to push the updated version number to Git
push_updated_version_to_git() {
  cd dmt-scripts-snowflake || exit

  # Configure the Git user
  git config user.email "paul.fry@payroc.com"
  git config user.name "paulfry-payroc"

  rm -rf .git/rebase-apply

  # Push the updated file to Git
  git add schemachange/_current_version.txt
  git commit -m "Updated schemachange/_current_version.txt"
  git pull --rebase origin "${SOURCE_GIT_BRANCH_NAME}"
  git push origin HEAD:"${SOURCE_GIT_BRANCH_NAME}"
}

#=======================================================================
# Main script logic
#=======================================================================

# For debugging, let's print out branch name we'll write to
echo -e "${YELLOW}#-----------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "${YELLOW}# Debugging: target branch = $SOURCE_GIT_BRANCH_NAME"
echo -e "${YELLOW}#-----------------------------------------------------------------------------------------------------------------------------------------------------"

# Check if the input file exists
if [ -e "$IP_FILE_PATH" ]; then
    # Read the file contents and assign it to a variable
    CURRENT_VERSION=$(cat "$IP_FILE_PATH")

    # Print the contents to verify
    echo -e "${YELLOW}#-----------------------------------------------------------------------------------------------------------------------------------------------------"
    echo -e "${YELLOW}# Step 1: Get the current latest version number"
    echo -e "${YELLOW}#-----------------------------------------------------------------------------------------------------------------------------------------------------"
    echo "Current version: $CURRENT_VERSION"

    echo -e "${YELLOW}#-----------------------------------------------------------------------------------------------------------------------------------------------------"
    echo -e "${YELLOW}# Step 2: Get the updated max version number from the changed files"
    echo -e "${YELLOW}#-----------------------------------------------------------------------------------------------------------------------------------------------------"

    # get the latest/largest version number of the changed files
    UPDATED_MAX_VERSION=$(get_latest_changed_file_version "$CURRENT_VERSION")
    echo "Current Max version: $UPDATED_MAX_VERSION"

    # Check if UPDATED_MAX_VERSION is larger than CURRENT_VERSION
    if [[ "$UPDATED_MAX_VERSION" > "$CURRENT_VERSION" ]]; then
        echo -e "${YELLOW}#-----------------------------------------------------------------------------------------------------------------------------------------------------"
        echo -e "${YELLOW}# Step 3: Write the updated version number back to schemachange/_current_version.txt"
        echo -e "${YELLOW}#-----------------------------------------------------------------------------------------------------------------------------------------------------"

        echo "${UPDATED_MAX_VERSION}" > "${IP_FILE_PATH}"

        echo -e "${YELLOW}#-----------------------------------------------------------------------------------------------------------------------------------------------------"
        echo -e "${YELLOW}# Step 4: Push the updated latest version number to Git"
        echo -e "${YELLOW}#-----------------------------------------------------------------------------------------------------------------------------------------------------"
        # push the updated version number to Git
        push_updated_version_to_git
    else
        echo "No changes to made: updated version number isn't larger than the current version number."
    fi

else
    echo "File not found: $IP_FILE_PATH"
fi

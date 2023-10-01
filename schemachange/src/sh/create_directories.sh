#!/usr/bin/env bash

PARENT_DIR="schemachange"

# 1. Create parent dir
mkdir ${PARENT_DIR}

mkdir ${PARENT_DIR}/1_users_roles_and_grants
touch ${PARENT_DIR}/1_users_roles_and_grants/.gitkeep
mkdir ${PARENT_DIR}/2_account_level_objects
touch ${PARENT_DIR}/2_account_level_objects/.gitkeep
mkdir ${PARENT_DIR}/3_schema_level_objects
touch ${PARENT_DIR}/3_schema_level_objects/.gitkeep
mkdir ${PARENT_DIR}/img
touch ${PARENT_DIR}/img/.gitkeep

# 2. Create dirs for 'grants' dir
mkdir ${PARENT_DIR}/1_users_roles_and_grants/grants/
touch ${PARENT_DIR}/1_users_roles_and_grants/grants/.gitkeep

# 3. Create dirs for '2_account_level_objects'
mkdir ${PARENT_DIR}/2_account_level_objects/database
mkdir ${PARENT_DIR}/2_account_level_objects/warehouse
touch ${PARENT_DIR}/2_account_level_objects/database/.gitkeep
touch ${PARENT_DIR}/2_account_level_objects/warehouse/.gitkeep

# 4. Create dirs for '3_schema_level_objects'
mkdir ${PARENT_DIR}/3_schema_level_objects/sp
touch ${PARENT_DIR}/3_schema_level_objects/sp/.gitkeep

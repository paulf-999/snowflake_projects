#!/usr/bin/env bash

# 1. create account_object dirs
mkdir account_objects
mkdir account_objects/database
mkdir account_objects/ext_function
mkdir account_objects/resource_monitor
mkdir account_objects/role
mkdir account_objects/user
mkdir account_objects/warehouse

# 2. create placeholder files
touch account_objects/database/.gitkeep
touch account_objects/ext_function/.gitkeep
touch account_objects/resource_monitor/.gitkeep
touch account_objects/role/.gitkeep
touch account_objects/user/.gitkeep
touch account_objects/warehouse/.gitkeep

# 3. create database_objects dirs
mkdir database_objects
mkdir database_objects/ext_table
mkdir database_objects/file_format
mkdir database_objects/materialized_view
mkdir database_objects/sp
mkdir database_objects/stage
mkdir database_objects/table
mkdir database_objects/task

# 4. create placeholder files
touch database_objects/.gitkeep
touch database_objects/ext_table/.gitkeep
touch database_objects/file_format/.gitkeep
touch database_objects/materialized_view/.gitkeep
touch database_objects/sp/.gitkeep
touch database_objects/stage/.gitkeep
touch database_objects/table/.gitkeep
touch database_objects/task/.gitkeep

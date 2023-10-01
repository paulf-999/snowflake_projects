-- Use the SYSADMIN role and the DEV_WH warehouse.
USE ROLE SYSADMIN;
USE WAREHOUSE DEV_WH;

-- Create the 'OPERATIONS' database if it doesn't exist.
CREATE DATABASE IF NOT EXISTS OPERATIONS COMMENT = "Database for operational tasks, excludes source system data."; -- noqa

-- Create the 'SCHEMACHANGE' schema within the 'OPERATIONS' database with managed access.
CREATE SCHEMA IF NOT EXISTS OPERATIONS.SCHEMACHANGE WITH MANAGED ACCESS COMMENT = "Schema used by the 'schemachange' tool to manage the deployment of version-controlled Snowflake objects"; -- noqa

-- Create the 'SODA_DQ' schema within the 'OPERATIONS' database with managed access.
CREATE SCHEMA IF NOT EXISTS OPERATIONS.SODA_DQ WITH MANAGED ACCESS COMMENT = "Schema utilised by the data quality tool 'soda core' to store output from data quality tasks"; -- noqa

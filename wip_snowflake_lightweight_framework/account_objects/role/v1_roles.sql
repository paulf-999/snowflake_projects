!SET variable_substitution=true;
/*
USE ROLE ACCOUNTADMIN;
DROP ROLE IF EXISTS &{PROGRAM}_&{ENV}_DBA;
DROP ROLE IF EXISTS &{PROGRAM}_&{ENV}_DATA_LOADER;
DROP ROLE IF EXISTS &{PROGRAM}_&{ENV}_DEVELOPER;
DROP ROLE IF EXISTS &{PROGRAM}_&{ENV}_ANALYST;
DROP ROLE IF EXISTS &{PROGRAM}_&{ENV}_VISUALISER;
DROP ROLE IF EXISTS &{PROGRAM}_&{ENV}_DBT_SVC;
DROP ROLE IF EXISTS &{PROGRAM}_&{ENV}_SF_TASK_ADMIN;
DROP ROLE IF EXISTS &{PROGRAM}_&{ENV}_SF_STAGE_ADMIN;
*/

--create the user roles
USE ROLE SECURITYADMIN;
CREATE ROLE IF NOT EXISTS &{PROGRAM}_&{ENV}_DBA COMMENT = 'DBA for the &{PROGRAM} DBs. This role owns all of the &{PROGRAM} databases and their constraints.';
CREATE ROLE IF NOT EXISTS &{PROGRAM}_&{ENV}_DATA_LOADER COMMENT = 'Used for loading data into &{PROGRAM} tables from Snowflake stages/ext tables/tables.';
CREATE ROLE IF NOT EXISTS &{PROGRAM}_&{ENV}_DEVELOPER COMMENT = 'Used to load data into the &{PROGRAM} tables. Also operates on the data for updates, inserts, truncates etc.';
CREATE ROLE IF NOT EXISTS &{PROGRAM}_&{ENV}_VISUALISER COMMENT = 'Used by reporting tool service account roles.';
CREATE ROLE IF NOT EXISTS &{PROGRAM}_&{ENV}_ANALYST COMMENT = 'Used for QA and analysis. Main purpose is querying and interacting with the data. Mostly read-only operations.';
CREATE ROLE IF NOT EXISTS &{PROGRAM}_&{ENV}_DBT_SVC COMMENT = 'Used by DBT to build the data model.';
CREATE ROLE IF NOT EXISTS &{PROGRAM}_&{ENV}_SF_TASK_ADMIN COMMENT = 'Admininstrator for Snowflake tasks.';
CREATE ROLE IF NOT EXISTS &{PROGRAM}_&{ENV}_SF_STAGE_ADMIN COMMENT = 'Admininstrator for Snowflake stages.';
CREATE ROLE IF NOT EXISTS &{PROGRAM}_&{ENV}_SF_SI_ADMIN COMMENT = 'Admininstrator for Snowflake storage integratons.';
CREATE ROLE IF NOT EXISTS &{PROGRAM}_&{ENV}_SF_TAG_ADMIN COMMENT = 'Adminstrator for creating and assigning tags to Snowflake objects.';

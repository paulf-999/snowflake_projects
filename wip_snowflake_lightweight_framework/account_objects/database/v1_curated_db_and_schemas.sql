!SET variable_substitution=true;
/*
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE &{PROGRAM}_&{ENV}_DEVELOPER_WH;
DROP DATABASE IF EXISTS &{PROGRAM}_&{ENV}_CURATED_DB;
*/

USE ROLE &{PROGRAM}_&{ENV}_DBA;
USE WAREHOUSE &{PROGRAM}_&{ENV}_DEVELOPER_WH;

--create curated_db structure
CREATE DATABASE IF NOT EXISTS &{PROGRAM}_&{ENV}_CURATED_DB COMMENT = 'Cleansed / Conformed data layer. Used to build a data model combining data from a variety of sources.';
CREATE SCHEMA IF NOT EXISTS &{PROGRAM}_&{ENV}_CURATED_DB.EDM WITH MANAGED ACCESS COMMENT = 'Enterprise data model (EDM) for the &{PROGRAM} Data Warehouse';
CREATE SCHEMA IF NOT EXISTS &{PROGRAM}_&{ENV}_CURATED_DB.UTILITIES WITH MANAGED ACCESS COMMENT = 'Contains all database objects other than tables or views';
CREATE SCHEMA IF NOT EXISTS &{PROGRAM}_&{ENV}_CURATED_DB.STG WITH MANAGED ACCESS COMMENT = 'Staging tables to support the data model';
DROP SCHEMA IF EXISTS &{PROGRAM}_&{ENV}_CURATED_DB.PUBLIC;

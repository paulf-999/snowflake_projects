!SET variable_substitution=true;
USE ROLE AGDF_DBA;
USE WAREHOUSE AGDF_DEVELOPER_WH;

--quickly drop the dbs
DROP DATABASE IF EXISTS &{ENV}_AGDF_RAW_DB;
DROP DATABASE IF EXISTS &{ENV}_AGDF_CURATED_DB;
DROP DATABASE IF EXISTS &{ENV}_AGDF_ANALYTICS_DB;

--create raw_db structure
CREATE DATABASE IF NOT EXISTS &{ENV}_AGDF_RAW_DB COMMENT = 'Ingestion / landing area, containing raw, non-transformed source system data';
CREATE SCHEMA IF NOT EXISTS &{ENV}_AGDF_RAW_DB.SIRIUS WITH MANAGED ACCESS COMMENT = 'Contains tables/data from the Sirius DB';
CREATE SCHEMA IF NOT EXISTS &{ENV}_AGDF_RAW_DB.CHECKGUARD WITH MANAGED ACCESS COMMENT = 'Contains tables/data from the Checkguard DB';
CREATE SCHEMA IF NOT EXISTS &{ENV}_AGDF_RAW_DB.UTILITIES WITH MANAGED ACCESS COMMENT = 'Contains all database objects other than tables or views';
DROP SCHEMA IF EXISTS &{ENV}_AGDF_RAW_DB.PUBLIC;

--create curated_db structure
CREATE DATABASE IF NOT EXISTS &{ENV}_AGDF_CURATED_DB COMMENT = 'Cleansed / Conformed data layer. Used to build a data model combining data from a variety of sources.';
CREATE SCHEMA IF NOT EXISTS &{ENV}_AGDF_CURATED_DB.NP WITH MANAGED ACCESS COMMENT = 'Non-prod data model for the AGDF Data Warehouse';
CREATE SCHEMA IF NOT EXISTS &{ENV}_AGDF_CURATED_DB.PROD WITH MANAGED ACCESS COMMENT = 'Prod data model for the AGDF Data Warehouse';
CREATE SCHEMA IF NOT EXISTS &{ENV}_AGDF_CURATED_DB.UTILITIES WITH MANAGED ACCESS COMMENT = 'Contains all database objects other than tables or views';
CREATE SCHEMA IF NOT EXISTS &{ENV}_AGDF_CURATED_DB.STG WITH MANAGED ACCESS COMMENT = 'Staging tables to support the data model';
DROP SCHEMA IF EXISTS &{ENV}_AGDF_CURATED_DB.PUBLIC;

--create analytics_db structure
CREATE DATABASE IF NOT EXISTS &{ENV}_AGDF_ANALYTICS_DB COMMENT = 'Application layer, where business logic has been applied allowing for the data to be ready for Tableau';
CREATE SCHEMA IF NOT EXISTS &{ENV}_AGDF_ANALYTICS_DB.NP_SCHEDULING_MART WITH MANAGED ACCESS COMMENT = 'Non-prod application layer for the scheduling reporting solution';
CREATE SCHEMA IF NOT EXISTS &{ENV}_AGDF_ANALYTICS_DB.PROD_SCHEDULING_MART  WITH MANAGED ACCESS COMMENT = 'Prod application layer for the scheduling reporting solution';
CREATE SCHEMA IF NOT EXISTS &{ENV}_AGDF_ANALYTICS_DB.UTILITIES WITH MANAGED ACCESS COMMENT = 'Contains all database objects other than tables or views';
CREATE SCHEMA IF NOT EXISTS &{ENV}_AGDF_ANALYTICS_DB.STG WITH MANAGED ACCESS COMMENT = 'Used to store staging tables';
DROP SCHEMA IF EXISTS &{ENV}_AGDF_ANALYTICS_DB.PUBLIC;

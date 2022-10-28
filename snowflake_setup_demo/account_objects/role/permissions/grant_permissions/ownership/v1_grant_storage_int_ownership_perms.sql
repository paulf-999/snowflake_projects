!SET variable_substitution=true;
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE &{PROGRAM}_DEVELOPER_WH;

--grant ownership of storage integration (SI) objects to the SI admin role
GRANT OWNERSHIP ON INTEGRATION &{PROGRAM}_S3_INT TO ROLE &{PROGRAM}_SF_SI_ADMIN;

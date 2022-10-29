!SET variable_substitution=true;
USE ROLE ACCOUNTADMIN;

--grant ownership of storage integration (SI) objects to the SI admin role
GRANT OWNERSHIP ON INTEGRATION &{PROGRAM}_&{ENV}_S3_INT TO ROLE &{PROGRAM}_&{ENV}_SF_SI_ADMIN;

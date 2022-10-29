!SET variable_substitution=true;
--grant '&{PROGRAM}_TAG_ADMIN' role 'execute task' privileges
USE ROLE ACCOUNTADMIN;
GRANT APPLY TAG ON ACCOUNT TO ROLE &{PROGRAM}_&{ENV}_SF_TAG_ADMIN;

!SET variable_substitution=true;
USE ROLE SECURITYADMIN;
CREATE ROLE IF NOT EXISTS &{PROGRAM}_&{ENV}_SF_SI_ADMIN COMMENT = 'Admininstrator for Snowflake storage integratons.';

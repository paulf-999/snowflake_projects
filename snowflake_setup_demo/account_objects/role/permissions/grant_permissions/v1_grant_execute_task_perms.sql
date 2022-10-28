!SET variable_substitution=true;
--grant '&{PROGRAM}_SF_TASK_ADMIN' role 'execute task' privileges
USE ROLE ACCOUNTADMIN;
GRANT EXECUTE TASK ON ACCOUNT TO ROLE &{PROGRAM}_SF_TASK_ADMIN;

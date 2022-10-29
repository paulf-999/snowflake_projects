!SET variable_substitution=true;
USE ROLE SECURITYADMIN;

CREATE USER IF NOT EXISTS EXAMPLE_USER
    LOGIN_NAME = 'example.user'
    PASSWORD = 'example'
    DISPLAY_NAME = 'Example User'
    EMAIL = 'example_user@email.com'
    DEFAULT_ROLE = ${PROGRAM}_${ENV}_ANALYST
    DEFAULT_WAREHOUSE = ${PROGRAM}_${ENV}_DEVELOPER_WH
    DEFAULT_NAMESPACE =
    MUST_CHANGE_PASSWORD = TRUE
    COMMENT = 'This is an example user.';

!SET variable_substitution=true;
USE ROLE &{PROGRAM}_&{ENV}_DBA;
USE WAREHOUSE &{PROGRAM}_&{ENV}_DEVELOPER_WH;
USE DATABASE &{PROGRAM}_&{ENV}_RAW_DB;
USE SCHEMA UTILITIES;

CREATE TASK IF NOT EXISTS REFRESH_&{DATA_SRC}_SFTP_DATA_EXT_TBL_TSK
    WAREHOUSE = &{PROGRAM}_&{ENV}_TRANSFORMATION_WH
    SCHEDULE = 'USING CRON 15 07 * * * Australia/Melbourne'
    --refresh the external table
    AS ALTER EXTERNAL TABLE &{DATA_SRC}.EXT_SFTP_DATA REFRESH;
    --execute task
    ALTER TASK REFRESH_&{DATA_SRC}_SFTP_DATA_EXT_TBL_TSK RESUME;

CREATE TASK IF NOT EXISTS REFRESH_&{DATA_SRC}_SFTP_DATA_TBL_TSK
    WAREHOUSE = &{PROGRAM}_&{ENV}_TRANSFORMATION_WH
    SCHEDULE = 'USING CRON 20 07 * * * Australia/Melbourne'
    --create table, using the refreshed ext tbl
    AS CREATE OR REPLACE TABLE &{DATA_SRC}.EG_TBL AS
        SELECT  TRY_TO_DATE(value:c1::varchar, 'DD/MM/YYYY') AS SETTLEMENT_DATE
                , value:c2::varchar AS SYS_TIMESTAMP
                , TO_TIMESTAMP_NTZ(value:c3::varchar, 'DD/MM/YYYY HH:MI') AS DTTM_LOCAL_TXN
                , value:c4::int AS CUST_DATA_PREFIX_ID
                , value:c5::varchar AS CUST_DATA_ISSUER_ID
                , value:c6::int AS TRL_ACQR_INST_ID
                , value:c7::int AS STAN
                , value:c8::int AS RRN
                , value:c9::varchar AS AUTHORISED_BY
                , value:c10::varchar AS MASKED_PAN
                , value:c11::varchar AS ISSUER_ORG_NAME
                , value:c12::varchar AS TERMINAL_ID
                , value:c13::int AS ACTION_RESPONSE_CODE
                , value:c14::varchar AS ISSUER_BIN
                , value:c15::int AS ISSUER_CLIENT_ID
                , value:c16::int AS ACQR_INST_ID
                , value:c17::varchar AS TRANSACTION_TYPE
                , value:c18::int AS DEC_COUNT
                , value:c19::int AS DEP_COUNT
                , value:c20::decimal(20,4) AS DEP_AMOUNT
                , value:c21::int AS ENQ_COUNT
                , value:c22::int AS RVD_COUNT
                , value:c23::decimal(20,4) AS RVD_AMOUNT
                , value:c24::int AS RVW_COUNT
                , value:c25::decimal(20,4) AS RVW_AMOUNT
                , value:c26::int AS TRF_COUNT
                , value:c27::int AS WDL_COUNT
                , value:c28::decimal(20,4) AS WDL_AMOUNT
                , value:c29::int AS DCW_COUNT
                , value:c30::decimal(20,4) AS DCW_AMOUNT
                , value:c31::int AS DWV_COUNT
                , value:c32::decimal(20,4) AS DWV_AMOUNT
                , value:c33::int AS DCE_COUNT
                , value:c34::decimal(20,4) AS DCE_AMOUNT
                , value:c35::int AS DEV_COUNT
                , value:c36::decimal(20,4) AS DEV_AMOUNT
                , value:c37::varchar AS TRAN_ACQR_NAME
                , value:c38::int AS TRAN_ACQR_CTY_ISO_CODE
                , value:c39::int AS CUST_PREFIX
                , value:c40::varchar AS CARD_TYPE
                , value:c41::varchar AS CARD_ISO_CODE
                , value:c42::varchar AS TRAN_QUALIFIER
                , value:c43::varchar AS TRAN_ORIG_CHANNEL
                , value:c44::int AS POS_COND_CODE
                , value:c45::decimal(20,4) AS TRAN_CHD_BILLING
                , value:c46::decimal(20,4) AS TRAN_ACQR_FEE
                , value:c47::varchar AS TRAN_TERM_LOCATION
                , value:c48::varchar AS TYPE_TTY_NAME
                , value:c49::varchar AS CODE_TSC_DESCRIPTION
                , SYS_SRC_FILENAME
                , '&{DATA_SRC}' AS SYS_LOAD_SRC
                , TO_TIMESTAMP_NTZ(CURRENT_TIMESTAMP) AS SYS_LOAD_TS
        FROM EXT_SFTP_DATA;
    --execute task
    ALTER TASK REFRESH_&{DATA_SRC}_SFTP_DATA_TBL_TSK RESUME;

CREATE TASK IF NOT EXISTS INSERT_RECORD_INTO_ETL_CONTROL_TBL_TSK
    WAREHOUSE = &{PROGRAM}_&{ENV}_TRANSFORMATION_WH
    SCHEDULE = 'USING CRON 25 07 * * * Australia/Melbourne'
    --refresh the external table
    AS INSERT INTO UTILITIES.ETL_CONTROL_TBL (JOB_NAME, DATA_SRC, TABLE_NAME, LOAD_TS, ROWS_UPDATED)
        SELECT  'data_ingestion_&{DATA_SRC}_full_load'
                , '&{DATA_SRC}'
                , 'SFTP_DATA'
                , CURRENT_TIMESTAMP
                , COUNT(*)
        FROM    &{DATA_SRC}.SFTP_DATA;
    --execute task
    ALTER TASK INSERT_RECORD_INTO_ETL_CONTROL_TBL_TSK RESUME;

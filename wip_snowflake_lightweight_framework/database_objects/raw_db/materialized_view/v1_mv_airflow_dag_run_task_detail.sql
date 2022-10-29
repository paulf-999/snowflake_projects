!SET variable_substitution=true;
USE ROLE &{PROGRAM}_&{ENV}_DATA_LOADER;
USE WAREHOUSE &{PROGRAM}_&{ENV}_LOADING_WH;
USE DATABASE &{PROGRAM}_&{ENV}_RAW_DB;
USE SCHEMA UTILITIES;

CREATE MATERIALIZED VIEW IF NOT EXISTS MV_AIRFLOW_DAG_RUN_TASK_DETAIL AS (
    SELECT DISTINCT
        DAG_NAME
        , DAG_RUN
        , DAG_RUN_TASK_NAME
        , DAG_RUN_TASK_STATE
        , DAG_RUN_TASK_START_DATE
        , DAG_RUN_TASK_END_DATE
        , DAG_RUN_TASK_DURATION
    FROM AIRFLOW_DAG_RUN
);
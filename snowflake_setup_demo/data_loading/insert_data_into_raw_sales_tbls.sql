!SET variable_substitution=true;
USE ROLE &{PROGRAM}_DBA;
USE WAREHOUSE &{PROGRAM}_DEVELOPER_WH;
USE DATABASE &{PROGRAM}_RAW_DB;
USE SCHEMA UTILITIES;

COPY INTO SALES.CUSTOMERS
    FROM  (
        SELECT  $1
                , $2
                , $3
                , $4
                , $5
                , $6
                , $7
                , $8
                , $9
                , metadata$FILENAME
                , CURRENT_TIMESTAMP
        FROM @&{PROGRAM}_STAGE/customers.csv.gz
    );

COPY INTO SALES.ORDERS
    FROM  (
        SELECT  $1
                , $2
                , $3
                , $4
                , $5
                , $6
                , $7
                , $8
                , metadata$FILENAME
                , CURRENT_TIMESTAMP
        FROM @&{PROGRAM}_STAGE/orders.csv.gz
    );

COPY INTO SALES.ORDER_ITEMS
    FROM  (
        SELECT  $1
                , $2
                , $3
                , $4
                , $5
                , $6
                , metadata$FILENAME
                , CURRENT_TIMESTAMP
        FROM @&{PROGRAM}_STAGE/order_items.csv.gz
    );

COPY INTO SALES.STAFFS
    FROM  (
        SELECT  $1
                , $2
                , $3
                , $4
                , $5
                , $6
                , $7
                , $8
                , metadata$FILENAME
                , CURRENT_TIMESTAMP
        FROM @&{PROGRAM}_STAGE/staffs.csv.gz
    );

COPY INTO SALES.STORES
    FROM  (
        SELECT  $1
                , $2
                , $3
                , $4
                , $5
                , $6
                , $7
                , $8
                , metadata$FILENAME
                , CURRENT_TIMESTAMP
        FROM @&{PROGRAM}_STAGE/stores.csv.gz
    );

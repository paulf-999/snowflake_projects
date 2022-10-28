!SET variable_substitution=true;
USE ROLE &{PROGRAM}_DBA;
USE WAREHOUSE &{PROGRAM}_DEVELOPER_WH;
USE DATABASE &{PROGRAM}_RAW_DB;
USE SCHEMA UTILITIES;

-- production schema inserts
COPY INTO PRODUCTION.CATEGORIES
    FROM (
        SELECT  $1
                , $2
                , metadata$FILENAME
                , CURRENT_TIMESTAMP
        FROM @&{PROGRAM}_STAGE/categories.csv.gz
    );

COPY INTO PRODUCTION.BRANDS
    FROM (
        SELECT  $1
                , $2
                , metadata$FILENAME
                , CURRENT_TIMESTAMP
        FROM @&{PROGRAM}_STAGE/brands.csv.gz
    );


COPY INTO PRODUCTION.PRODUCTS
    FROM  (
        SELECT  $1
                , $2
                , $3
                , $4
                , $5
                , $6
                , metadata$FILENAME
                , CURRENT_TIMESTAMP
        FROM @&{PROGRAM}_STAGE/products.csv.gz
    );

COPY INTO PRODUCTION.STOCKS
    FROM  (
        SELECT  $1
                , $2
                , $3
                , metadata$FILENAME
                , CURRENT_TIMESTAMP
        FROM @&{PROGRAM}_STAGE/stocks.csv.gz
    );

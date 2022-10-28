!SET variable_substitution=true;
USE ROLE &{PROGRAM}_DBA;
USE WAREHOUSE &{PROGRAM}_DEVELOPER_WH;
USE DATABASE &{PROGRAM}_RAW_DB;
USE SCHEMA UTILITIES;

-- production schema
PUT file://ip/production/brands.csv @&{PROGRAM}_STAGE OVERWRITE = TRUE AUTO_COMPRESS = TRUE;
PUT file://ip/production/categories.csv @&{PROGRAM}_STAGE OVERWRITE = TRUE AUTO_COMPRESS = TRUE;
PUT file://ip/production/products.csv @&{PROGRAM}_STAGE OVERWRITE = TRUE AUTO_COMPRESS = TRUE;
PUT file://ip/production/stocks.csv @&{PROGRAM}_STAGE OVERWRITE = TRUE AUTO_COMPRESS = TRUE;

-- sales schema
PUT file://ip/sales/customers.csv @&{PROGRAM}_STAGE OVERWRITE = TRUE AUTO_COMPRESS = TRUE;
PUT file://ip/sales/order_items.csv @&{PROGRAM}_STAGE OVERWRITE = TRUE AUTO_COMPRESS = TRUE;
PUT file://ip/sales/orders.csv @&{PROGRAM}_STAGE OVERWRITE = TRUE AUTO_COMPRESS = TRUE;
PUT file://ip/sales/staffs.csv @&{PROGRAM}_STAGE OVERWRITE = TRUE AUTO_COMPRESS = TRUE;
PUT file://ip/sales/stores.csv @&{PROGRAM}_STAGE OVERWRITE = TRUE AUTO_COMPRESS = TRUE;

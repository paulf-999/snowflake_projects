!SET variable_substitution=true;
USE ROLE &{PROGRAM}_&{ENV}_DBA;
USE WAREHOUSE &{PROGRAM}_&{ENV}_DEVELOPER_WH;
USE DATABASE &{PROGRAM}_&{ENV}_RAW_DB;
USE SCHEMA UTILITIES;

-- production schema
PUT file://ip/production/brands.csv @&{PROGRAM}_&{ENV}_STAGE OVERWRITE = TRUE AUTO_COMPRESS = TRUE;
PUT file://ip/production/categories.csv @&{PROGRAM}_&{ENV}_STAGE OVERWRITE = TRUE AUTO_COMPRESS = TRUE;
PUT file://ip/production/products.csv @&{PROGRAM}_&{ENV}_STAGE OVERWRITE = TRUE AUTO_COMPRESS = TRUE;
PUT file://ip/production/stocks.csv @&{PROGRAM}_&{ENV}_STAGE OVERWRITE = TRUE AUTO_COMPRESS = TRUE;

-- sales schema
PUT file://ip/sales/customers.csv @&{PROGRAM}_&{ENV}_STAGE OVERWRITE = TRUE AUTO_COMPRESS = TRUE;
PUT file://ip/sales/order_items.csv @&{PROGRAM}_&{ENV}_STAGE OVERWRITE = TRUE AUTO_COMPRESS = TRUE;
PUT file://ip/sales/orders.csv @&{PROGRAM}_&{ENV}_STAGE OVERWRITE = TRUE AUTO_COMPRESS = TRUE;
PUT file://ip/sales/staffs.csv @&{PROGRAM}_&{ENV}_STAGE OVERWRITE = TRUE AUTO_COMPRESS = TRUE;
PUT file://ip/sales/stores.csv @&{PROGRAM}_&{ENV}_STAGE OVERWRITE = TRUE AUTO_COMPRESS = TRUE;

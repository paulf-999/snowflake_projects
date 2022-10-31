#!/usr/bin/env python
import logging
import os

import snowflake.connector
import yaml


def get_logger():
    """Set up a specific logger with our desired output level"""
    logging.basicConfig(format="%(message)s")
    logger = logging.getLogger("application_logger")
    logger.setLevel(logging.INFO)

    return logger


def read_ip():
    """Read input from config file"""

    working_dir = os.getcwd()

    with open(os.path.join(working_dir, "ip", "config_mine.yaml")) as ip_yml:
        # with open(os.path.join(working_dir, "ip", "config.yaml")) as ip_yml:
        data = yaml.safe_load(ip_yml)

    snowflake_username = data["db_connection_params"]["snowflake_username"]
    snowflake_pass = data["db_connection_params"]["snowflake_pass"]
    snowflake_account = data["db_connection_params"]["snowflake_account"]
    snowflake_wh = data["db_connection_params"]["snowflake_wh"]
    snowflake_db = data["db_connection_params"]["snowflake_db"]
    snowflake_db_schema = data["db_connection_params"]["snowflake_db_schema"]

    return snowflake_username, snowflake_pass, snowflake_account, snowflake_wh, snowflake_db, snowflake_db_schema


def main():
    """Main entry point of the app"""
    logger = get_logger()

    # get inputs
    snowflake_username, snowflake_pass, snowflake_account, snowflake_wh, snowflake_db, snowflake_db_schema = read_ip()

    conn = snowflake.connector.connect(
        user=snowflake_username,
        password=snowflake_pass,
        account=snowflake_account,
        warehouse=snowflake_wh,
        database=snowflake_db,
        schema=snowflake_db_schema
    )

    cursor = conn.cursor()
    # query = "SELECT current_version()"
    query = "desc table products;"

    with open("query_op.csv", "w") as query_op:

        try:
            cursor.execute(query)
            # one_row = cursor.fetchone()
            query_result = cursor.fetchall()
            for tuple_result in query_result:
                logger.info(f"{str(tuple_result)}")
                for column in tuple_result:
                    query_op.write(f"{column};")
                query_op.write("\n")
        finally:
            cursor.close()

        conn.close()

    return


if __name__ == "__main__":
    """This is executed when run from the command line"""

    main()

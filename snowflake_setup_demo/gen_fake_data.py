#!/usr/bin/env python3
"""
Python Version  : 3.8
# TODO: change these
* Name          : boilerplate_basic.py
* Description   : Boilerplate python script
* Created       : 26-02-2021
* Usage         : python3 boilerplate_python_script.py
"""

__author__ = "Paul Fry"
__version__ = "1.0"

from datetime import datetime, timedelta
import logging
import pandas as pd
from faker import Faker
import random
import string

# create and initialize a faker generator. Ireland localisation arg provided
fake_generator = Faker("en_IE")

current_dt_obj = datetime.now()
# Can use 'current_dt_obj' to get other date parts. E.g. 'current_dt_obj.year'
current_date_str = current_dt_obj.strftime("%d-%m-%Y")
current_time_str = current_dt_obj.strftime("%H:%M:%S")


def get_logger():
    """Set up a specific logger with our desired output level"""
    logging.basicConfig(format="%(message)s")
    logger = logging.getLogger("application_logger")
    logger.setLevel(logging.INFO)

    return logger


def determine_col_dt(row):
    """Description here"""
    logger = get_logger()

    row_num = 5

    logger.info(f"{row['col_name']}, {row['data_type']}")

    if row['data_type'].startswith("NUMBER"):
        logger.info("NUMBER!")

        gen_fake_numeric_data(row, row_num)

    elif row['data_type'].startswith("VARCHAR"):
        logger.info("STRING!")

        gen_fake_string_data(row, row_num)

    elif row['data_type'].startswith("TIMESTAMP"):
        logger.info("TIMESTAMP!")

        gen_fake_date_time_data(row, row_num)

    return


def gen_fake_numeric_data(row, row_num):

    fake_numeric_data = []

    if row['data_type'].startswith('NUMBER'):

        split_str = row['data_type'].split("(")[1].split(",")
        precision = split_str[0]
        # scale = split_str[1].split(")")[0]

        print(precision.MAX_PREC)

        # generate random number to (max) precision
        # print(random.randint(1, int(precision)))

        # for _ in range(row_num):
        # generate random number to (max) precision
        # fake_numeric_data.append(random.randint(1, precision))

    for a in fake_numeric_data:
        print(a)

    return


def gen_fake_string_data(row, row_num):

    fake_string_data = []
    random_string = ''

    if row['col_name'].upper() == 'PRODUCT_NAME':
        print("yep")
        for _ in range(row_num):
            fake_string_data.append(fake_generator.first_name())

    elif row['data_type'].startswith('VARCHAR'):
        varchar_length = row['data_type'].split("(")[1].split(")")[0]

        letters = string.ascii_lowercase

        for _ in range(row_num):
            random_string = ''.join(random.choice(letters) for i in range(int(varchar_length)))
            fake_string_data.append(random_string)

    # for debugging
    # for i in fake_string_data:
    #    print(i)

    return


def gen_fake_date_time_data(row, row_num):

    # TODO: multiple checks, e.g.: date vs datetime vs time?

    fake_date_time_data = []

    for _ in range(row_num):
        fake_date_time_data.append(fake_generator.date_between(current_dt_obj - timedelta(days=5), current_dt_obj))

    # for debugging
    # for i in fake_date_time_data:
    #    logger.info(i)

    return fake_date_time_data


def main():
    """Main entry point of the app"""

    col_names = [
        "col_name", "data_type", "kind", "null", "default", "primary_key", "unique_key", "check", "expression", "comment", "policy_name", "b"
    ]
    df = pd.read_csv("query_op.csv", sep=';', names=col_names).reset_index()

    # logger.info(df)

    for index, row in df.iterrows():
        # print(f"{row['col_name']}, {row['data_type']}")

        determine_col_dt(row)

    return df


if __name__ == "__main__":
    """This is executed when run from the command line"""

    main()

    # gen_fake_date_time_data('a', 5)

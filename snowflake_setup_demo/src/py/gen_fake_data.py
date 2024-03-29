#!/usr/bin/env python3
"""
Python Version  : 3.8
# TODO: change these
* Name          : boilerplate_basic.py
* Description   : Boilerplate python script
* Created       : 26-02-2021
* Usage         : python3 boilerplate_python_script.py
"""

__author__ = 'Paul Fry'
__version__ = '1.0'

import logging
import pandas as pd

# custom modules
import inputs
import dt_data_generation as dt_generator

# Set up a specific logger with our desired output level
logging.basicConfig(format='%(message)s')
logger = logging.getLogger('application_logger')
logger.setLevel(logging.INFO)


def process_generated_sql(generated_sql, row, column_count, df, fake_data):
    # append the generated output to the SQL 'insert into' statement
    logger.debug(f'column_count= {column_count}')

    # put quotes around `fake_data` if it's a string
    if row['data_type'].startswith('VARCHAR'):
        fake_data = f"'{fake_data}'"

    if column_count != len(df):
        generated_sql += f'{fake_data}, '
        column_count += 1
    else:
        generated_sql += f'{fake_data}'

    return generated_sql, column_count


def orchestrate_fake_data_generation(row, generated_sql, df, column_count):
    """Main entry point of the app"""

    logger.info(f"{row['col_name']}, {row['data_type']}")

    # these 3 vars are lists used to store generated fake data
    fake_numeric_data = fake_string_data = fake_date_time_data = []

    if row['data_type'].startswith('VARCHAR'):
        logger.info('\nSTRING!')
        fake_string_data = dt_generator.gen_fake_string_data(row)

        # append the generated output to the SQL 'insert into' statement
        generated_sql, column_count = process_generated_sql(generated_sql, row, column_count, df, fake_string_data)

    if row['data_type'].startswith('NUMBER'):
        logger.info('\nNUMBER!')
        fake_numeric_data = dt_generator.gen_fake_numeric_data(row)

        # append the generated output to the SQL 'insert into' statement
        generated_sql, column_count = process_generated_sql(generated_sql, row, column_count, df, fake_numeric_data)

    if row['data_type'].startswith('TIMESTAMP'):
        logger.info('\nTIMESTAMP!')
        fake_date_time_data = dt_generator.gen_fake_date_time_data(row)

        # append the generated output to the SQL 'insert into' statement
        generated_sql, column_count = process_generated_sql(generated_sql, row, column_count, df, fake_date_time_data)

    return generated_sql


def generate_fake_data(input_tbl, df, num_records):
    """For a given input table, generate X (num_records) fake records"""

    # generated_sql will be continually be appended to in orchestrate_fake_data_generation()
    generated_sql = f'INSERT INTO {input_tbl.upper()} VALUES \n'
    logger.debug(f'len(df) = {len(df)}')

    # generate the fake data for the amount of rows specified by `num_records`
    for row_to_generate in range(0, int(num_records)):

        # reset the column count for each record being generated
        column_count = 1
        generated_sql += '('

        # Determine the data types of the table schema
        for index, row in df.iterrows():

            # generated_sql += orchestrate_fake_data_generation(row, generated_sql, df, column_count=1)

            logger.info(f"col_name: {row['col_name']}\ndata_type: {row['data_type']}")

            # these 3 vars are lists used to store generated fake data
            fake_numeric_data = fake_string_data = fake_date_time_data = []

            if row['data_type'].startswith('VARCHAR'):
                logger.info('\nSTRING!')
                fake_string_data = dt_generator.gen_fake_string_data(row)

                # append the generated output to the SQL 'insert into' statement
                generated_sql, column_count = process_generated_sql(generated_sql, row, column_count, df, fake_string_data)

            if row['data_type'].startswith('NUMBER'):
                logger.info('\nNUMBER!')
                fake_numeric_data = dt_generator.gen_fake_numeric_data(row)

                # append the generated output to the SQL 'insert into' statement
                generated_sql, column_count = process_generated_sql(generated_sql, row, column_count, df, fake_numeric_data)

            if row['data_type'].startswith('TIMESTAMP'):
                logger.info('\nTIMESTAMP!')
                fake_date_time_data = dt_generator.gen_fake_date_time_data(row)

                # append the generated output to the SQL 'insert into' statement
                generated_sql, column_count = process_generated_sql(generated_sql, row, column_count, df, fake_date_time_data)

        generated_sql += ')\n'

    generated_sql += ';'

    with open(f'op/fake_data/{input_tbl}.csv', 'w') as op_sql:
        # logger.info(generated_sql)
        op_sql.write(generated_sql)


def read_table_schema(input_tbl):
    """read the table schema into a df"""
    # sf table schema for 'describe() function output
    col_names = [
        'col_name', 'data_type', 'kind', 'null', 'default', 'primary_key', 'unique_key', 'check', 'expression', 'comment', 'policy_name', '-'
    ]

    df = pd.read_csv(f'tmp/table_schemas/{input_tbl}.csv', sep=';', names=col_names).reset_index()
    logger.debug(df)

    return df


if __name__ == '__main__':
    """This is executed when run from the command line"""

    input_tbls, num_records = inputs.get_general_params()

    for input_tbl in input_tbls:
        # fetch the schema of the given input table
        # TODO: uncomment this when everything else is ready
        # snowflake_query.get_table_schema(input_tbl)

        # read the table schema into a df
        df = read_table_schema(input_tbl)

        # invoke the main orchestration logic per-input table
        generate_fake_data(input_tbl, df, num_records)

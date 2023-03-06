#!/usr/bin/env python3
"""
Script to extract the desired parts of snowflake query output
"""

__author__ = 'Paul Fry'
__version__ = '0.1'

import sys


def process_snowflake_vpcid_query_op(line):
    """ function to search for the string 'snowflake-vpc-id' and extract the corresponding vpc-id value """
    if 'snowflake-vpc-id' in line:
        vpcid = line[line.find('[')+1:line.find(']')].replace('"', '').replace('\n', '')
        print(vpcid)

    return


def process_snowflake_iam_user_query_op(line, sf_acc_name):
    """ function search for the strings 'STORAGE_AWS_IAM_USER_ARN', 'STORAGE_AWS_EXTERNAL_ID'
    and extract the corresponding values """
    iam_user_arn, aws_ext_id = '', ''

    if ip_param == 'get_snowflake_iam_user_arn':
        if 'STORAGE_AWS_IAM_USER_ARN' in line:
            iam_user_arn = line[line.find('arn:aws:iam')::].replace(' ', '').replace('|', '').replace('\n', '')
            print(iam_user_arn)
    elif ip_param == 'get_ext_id':
        if 'STORAGE_AWS_EXTERNAL_ID' in line:
            aws_ext_id = line[line.find(f'{sf_acc_name}_SFCRole=')::].replace(' ', '').replace('|', '').replace('\n', '')
            print(aws_ext_id)

    return


if __name__ == '__main__':
    # cmd line ip param
    ip_param = sys.argv[1]
    sf_acc_name = sys.argv[2]

    if ip_param == 'get_snowflake_vpcid':
        ip_file = 'op/stg/snowflake-query-op/snowflake-vpcid.txt'
    elif ip_param == 'get_snowflake_iam_user_arn' or ip_param == 'get_ext_id':
        ip_file = 'op/stg/snowflake-query-op/snowflake-iam-user.txt'

    with open(ip_file) as ip_file:
        for line in ip_file:
            if ip_param == 'get_snowflake_vpcid':
                process_snowflake_vpcid_query_op(line)
            elif ip_param == 'get_snowflake_iam_user_arn' or ip_param == 'get_ext_id':
                process_snowflake_iam_user_query_op(line, sf_acc_name)

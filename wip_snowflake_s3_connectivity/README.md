## Snowflake-S3-Connectivity

Automation script to orchestrate of the steps required establish communication between an S3 bucket and Snowflake, using Snowflake Storage Integration objects. This script looks to automate the steps described here - https://docs.snowflake.com/en/user-guide/data-load-s3-config-storage-integration.html

---

## Contents

1. High-level summary
2. Getting started
    * Prerequisites
3. How-to run
    * Input parameters

---

## 1. High-level summary

A `makefile` has been used to orchestrate the steps required to create a Snowflake Storage Integration object. Where these steps consist of:

1) Updating the S3 Bucket Policies for the source S3 bucket
    * To allow communication from the VPC ID of the  cluster
2) Creating an AWS IAM role, initially with a trust policy against your AWS account ID (this is subsequently revised in step 4)
3) Creating the Snowflake Storage Integration Object
4) And then revising the IAM role created in step 2, to use Snowflake-generated IAM entity details

---

## 2. Getting started

### Prerequisites

Before you begin, ensure you have met the following requirements:

| Mandatory / Optional | Prerequisite | Steps |
| -------| -----------| ------------------|
| Mandatory | Install [SnowSQL](https://docs.snowflake.com/en/user-guide/snowsql.html) and configure a SnowSQL [*named connection*](https://docs.snowflake.com/en/user-guide/snowsql-start.html#using-named-connections) | Once you've created a [*named connection*](https://docs.snowflake.com/en/user-guide/snowsql-start.html#using-named-connections), update the value of the corresponding key `SnowflakeNamedConn` within `env/env_example.json`. |

### How-to run:

The steps involved in building and executing involve:

1) Updating the input parameters within `env/env_example.json` (described below)
2) and running `make -f setup_s3_connectivity.mk`!

---

#### Input parameters (within `env/env_example.json`)

Described below are the input parameters (from the file `env/env_example.json`) that are required for the framework:

| Parameter | Description | Example | Mandatory |
|---|---|---|---|
| `Program` | * Accronym to describe the program of work<br/>* Used extensively to prefix DB/account objects<br/>* Note: hyphens, spaces or underscores aren't allowed for this value | `DFP` <br/>(accronym for 'Data Foundations Project') | Yes  |
| `Environment` | * The environment type<br/>* Used extensively, to prefix DB/account objects | `NP` (Non-Prod), `PROD` | Yes |
| `AwsProfile` | The name of your AWS named profile used for AWS CLI commands | `eg_aws_profile` | Yes |
| `AwsAccountId` | A 12-digit number that uniquely identifies an AWS account | `123456789012` | Yes |
| `SnowflakeAccountName` | * The name of the Snowflake account<br/>* This is the first few letters that proceed the AWS region in the Snowflake UI URL<br/>* E.g. `EG_SF_ACC_NAME.ap-southeast-2.snowflakecomputing.com` | `EG_SF_ACC_NAME` | Yes |
| `SnowflakeNamedConn` | * Refers to the value of a Snowflake 'named connection'<br/>* [`snowsql`](https://docs.snowflake.com/en/user-guide/snowsql.html) stores connection details within a configuration file<br/>* The default path to the configuration file is `~/.snowsql/config`<br/>* See [Snowflake Named Connections](https://docs.snowflake.com/en/user-guide/snowsql-start.html#using-named-connections) | `eg_sf_profile` | Yes |
| `SnowflakeDBAUser` | * Name of the Snowflake DBA user | `JBloggs` | Yes |
| `SnowflakeIAMRoleName` | * Name of the AWS IAM role to be created by the framework<br/>* Role to be used to allow comms between S3 bucket(s) and Snowflake | `${PROGRAM}-snowflake-access-role` | Yes |
| `SnowflakeVPCID` | * The ID of the VPC in which Snowflake resides within<br/>* Retrieved by running the Snowflake query:<br/>`SELECT system$$get_snowflake_platform_info();`<br/>* `ACCOUNTADMIN` privileges are required to run this query | `vpc-123f12e1` | Yes |
| `S3BucketEg` | * The name of the S3 bucket to load data into Snowflake from | `s3://eg-s3-bucket` | Yes |

## Usecase 
- With this , you can create glue job

## Pre-Requisite
-   This template will only work in the LZ-Connected Account

## Parameters to pass 


### Sample 
- glue-job.cf.yml
```yaml

UAI: uai3064620  #Description: This is the App UAI

AppName: test  #Description: AppName, keep to 15 characters or less.

Env: stg  #Description: This is the Environment for which we are deploying the resource

AWSGlueJobRole: arn:aws:iam::992382426084:role/vn/bot-lawgiver  #Description: 

GlueVersion: 4.0  #Description: GlueVersion

ArtifactBucketName: app-uai3064620-s3-bucket-test-qa-s3-s3-bucket-503401526-qa-test  #Description: 

ETLScriptsPrefix: test  #Description: prefix name

ScriptName: test  #Description: name of the script 

```
### Explanation of Parameters
```
UAI:
    Type: String
    Description: The UAI of the application being managed. UAI starting sequence. MUST be in lowercase.
    ConstraintDescription: The UAI must be valid, but specified as uai in lower case followed by 7 digits
    AllowedPattern: ^uai[0-9]*$
    MinLength: !!int 10
    MaxLength: !!int 10   

  AppName:
    Type: String
    Description: 'Which instance of the application. Example: app1. Must be lowercase. Max 15 chars.'
    AllowedPattern: ^[a-z][a-z0-9\._\-]*[a-z0-9]$
    ConstraintDescription: Must contain only lower case letters, digits or -. Min 3 chars. Max 15. Must start with a letter and end with a letter or digit
    MinLength: !!int 3
    MaxLength: !!int 15

  Env:
    Type: String
    Description: Env instance of the resource.
    Default: dev
    AllowedValues:
    - dev
    - qa
    - stg
    - prd

  AWSGlueJobRole:
    Type: String
    Description: Role for Glue Job

  glueVersion:
    Type: String
    Description: Provide Latest Glue version

  ArtifactBucketName:
    Type: String
    MinLength: "1"
    Description: "Name of the S3 bucket in which the Marketing and Sales ETL scripts reside. Bucket is NOT created by this CFT."

  ETLScriptsPrefix:
    Type: String
    MinLength: "1"
    Description: "Location of the Glue job ETL scripts in S3."
  
  scriptName:
    Type: String
    MinLength: "1"
    Description: "Name of the Glue job ETL scripts in S3. (Ex..test_process.py)"
```
### Dependency on Other AWS resources ?
-   ArtifactBucketName
-   AWSGlueJobRole

## History

### glue-job.cf.yml
- Initial Release glue-job.cf.yml


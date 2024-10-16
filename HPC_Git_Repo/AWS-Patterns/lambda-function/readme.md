## Usecase 
-  With this , you can create Lambda function to be invoked by event rule.

## Pre-Requisite

-   IAM Roles and Policies - You need an IAM role that the Lambda function will assume during execution. This role must have the necessary permissions to access the required AWS resources.
-   S3Key - The S3 key is essentially the full path to the object within the bucket, excluding the bucket name. It is used to retrieve, manage, and manipulate objects in S3.

## Parameters to pass 

### Sample 
- lambda-function.cf.yml
```yaml

UAI: uai3064620  #Description: Name of the application

SubnetIds: subnet-0821dff420052e1eb  #Description: Comma Seperated Subnets to be attacked to the Lambda
    
S3Key: LambdaScript/lambdacode.zip  #Description:  Where is the code in the s3 bucekt ? Key without bucketname
  
AppName: lambdatest  #Description: Name of the application
  
MemorySize: 128  #Description: What is the memory allocation to the lambda function ?
  
Timeout: 60  #Description: What is the timeout for the lambda function ?
  
Env: qa  #Description: Environment of the application
  
AppInstance: web  #Description: 'App Instance for ex: app, web'
  
LambdaHandlerPath: notification

LambdaRole: arn:aws:iam::992382426084:role/app-uai3064620/app-uai3064620-lzinfra-dev-lambda-exec-role   #Description: Lambda role ARN
 
LambdaBucket: uai3064620-lzinfra-dev-s3-code-deploy  #Description: Kms Key Arn value to encrypt the volume
  
VPCConfig: true

Runtime: python3.11
#Description: What is your runtime is ? choose one of these nodejs | nodejs4.3 | nodejs6.10 | nodejs8.10 | nodejs10.x | nodejs12.x | nodejs14.x | nodejs16.x | java8 | java8.al2 | java11 | python2.7 | python3.6 | python3.7 | python3.8 | python3.9 | dotnetcore1.0 | dotnetcore2.0 | dotnetcore2.1 | dotnetcore3.1 | dotnet6 | dotnet8 | nodejs4.3-edge | go1.x | ruby2.5 | ruby2.7 | provided | provided.al2 | nodejs18.x | python3.10 | java17 | ruby3.2 | python3.11 | nodejs20.x | provided.al2023 | python3.12 | java21
    
Usage: My lambda Function    #Default: 'My lambda Function new'

```

### Explanation of Parameters
```
  UAI:
    Type: String
    Description: Name of the application
  SubnetIds: 
    Type: CommaDelimitedList
    Description: Comma Seperated Subnets to be attacked to the Lambda
    Default: ''
  S3Key:
    Type: String
    Description:  Where is the code in the s3 bucekt ? Key without bucketname
    Default: LambdaScript/lambdacode.zip
  AppName:
    Type: String
    Description: Name of the application
  MemorySize:
    Type: Number
    Description: What is the memory allocation to the lambda function ?
    Default: 128
  Timeout:
    Type: Number
    Description: What is the timeout for the lambda function ?
    Default: 60
  Env:
    Type: String
    Description: Environment of the application
    AllowedValues:
      - dev
      - qa
      - stg
      - prd
  AppInstance:
    Type: String
    Description: 'App Instance for ex: app, web'
  LambdaHandlerPath:
    Type: String
    Description: Path of a Lambda Handler.
    AllowedPattern: '^.*[^0-9]$'
    ConstraintDescription: Must end with non-numeric character.
  LambdaRole:
    Type: String
    Description: Lambda role ARN
  LambdaBucket:
    Type: String
    Description: Kms Key Arn value to encrypt the volume
  VPCConfig:
    Type: String
    Description: 'true/false'
    AllowedValues:
      - 'true'
      - 'false'
  Runtime:
    Type: String
    Description: What is your runtime is ? choose one of these nodejs | nodejs4.3 | nodejs6.10 | nodejs8.10 | nodejs10.x | nodejs12.x | nodejs14.x | nodejs16.x | java8 | java8.al2 | java11 | python2.7 | python3.6 | python3.7 | python3.8 | python3.9 | dotnetcore1.0 | dotnetcore2.0 | dotnetcore2.1 | dotnetcore3.1 | dotnet6 | dotnet8 | nodejs4.3-edge | go1.x | ruby2.5 | ruby2.7 | provided | provided.al2 | nodejs18.x | python3.10 | java17 | ruby3.2 | python3.11 | nodejs20.x | provided.al2023 | python3.12 | java21
  Usage:
    Type: String
    Default: 'My lambda Function'
 

```

### Dependency on Other AWS resources ?
-   IAM and s3 Should be available

## History

### lambda-function.cf.yml
- Initial lambda-function.cf.yml

### lambda-function.v0.1.cf.yml
- Added SGId and updated the s3 bucket parameter description

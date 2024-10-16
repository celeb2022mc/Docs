## Usecase 
- With this , you can create Kinesis DataStream

## Pre-Requisite
-   None

## Parameters to pass 


### Sample 
- kinesis-data-stream.cf.yml
```yaml

UAI: uai3064620  #Description: This is the App UAI

AppName: test  #Description: AppName, keep to 15 characters or less.

Env: stg  #Description: This is the Environment for which we are deploying the resource

StreamName: test  #Description: The name to use for the service Kinesis DataStream

KmsKey: arn:aws:kms:us-east-1:992382426084:key/8e3cb2f9-acbc-41b7-8826-183520758e52  #Description: Kinesis DataStream uses AWS Key Management Service (KMS) to encrypt your data at rest

StreamMode: ON_DEMAND  #Description: strean mode to use for the service Kinesis DataStream


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

  StreamName:
    Type: String
    Description: The name to use for the service Kinesis DataStream
  
  KmsKey:
    Type: String
    Description: Kinesis DataStream uses AWS Key Management Service (KMS) to encrypt your data at rest

  streamMode:
    Type: String
    Description: strean mode to use for the service Kinesis DataStream
    AllowedValues:
      - ON_DEMAND
      - PROVISIONED
	  
```
### Dependency on Other AWS resources ?
-   KmsKey 

## History

### kinesis-data-stream.cf.yml
- Initial Release kinesis-data-stream.cf.yml


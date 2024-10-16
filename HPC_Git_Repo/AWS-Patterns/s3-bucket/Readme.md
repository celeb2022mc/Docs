## Usecase 
-  With this , you can create s3

## Pre-Requisite

-   This template will work in all kind of accounts 


## Parameters to pass 

### Sample 
- s3-bucket.cf.yml


```yaml

UAI: uai3064620  # This should be your application UAI

AppName: s3-bucket-test # This should be your app name. should be shortened to 7 to 8 characters without any spaces or _ or - or any special characters

Env: qa  #Description: This is the Environment for which we are deploying the resource

ObjectName: s3-bucket-503401526-qa-test  #Description: The name of the S3 Bucket to create 

AccessControl: Private  #Description: ensure that only authorized users and services can access your data

AWSAccountName: Test  #Description: 'The Aws Account Name'

VersioningConfiguration: Enabled  #Description: Versioning in S3 allows you to keep multiple versions of an object in one bucket

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
    Description: 'Which instance of the application. Example: app1. Must be lowercase. Max 30 chars.'
    AllowedPattern: ^[a-z][a-z0-9\._\-]*[a-z0-9]$
    ConstraintDescription: Must contain only lower case letters, digits or -. Min 3 chars. Max 30. Must start with a letter and end with a letter or digit
    MinLength: !!int 3
    MaxLength: !!int 15
  Env:
    Type: String
    Description: Environment of the application   
    AllowedValues:
    - dev
    - qa
    - stg
    - prd
  ObjectName:
    Type: String
    Description: The name of the S3 Bucket to create
  AccessControl:
    Type: String
    Default: Private
    AllowedValues:
    - Private
    - PublicRead
    - PublicReadWrite
    - AuthenticatedRead
    - LogDeliveryWrite
    - BucketOwnerRead
    - BucketOwnerFullControl

  AWSAccountName:
    Type: String
    Description: 'The Aws Account Name'
  VersioningConfiguration:
    Type: String
    AllowedValues:
    - Enabled
    - Suspended

```

### Dependency on Other AWS resources ?
-   None

## History

### s3-bucket.cf.yml
- Initial Release s3-bucket.cf.yml


### s3-bucket.v0.1.cf.yml
- Remove UAIValue to UAI

### s3-bucket.v0.2.cf.yml
- Added S3Bucket as an output and removed encrypted from the resource and everything is encrypted

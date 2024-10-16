## Usecase 
- With this , you can create an IAM User

## Pre-Requisite
-   None

## Parameters to pass 


### Sample 
- iam-user.cf.yml
```yaml

FunctionalUser: 50340000 #Description: This is the functional User Id

UAI: uai3064620 #Description: This is the App UAI

AppName: ajiamuser  #Description: This is the Application name

ArtifactBucketPath: arn:aws:s3:::uai3064620-lzinfra-dev-s3-code-deploy  #S3 BUCKET Path ARN

Env: dev  #Description: This is the Environment for which we are deploying the resource

```
### Explanation of Parameters
```
FunctionalUser:
  Type: String
  Description: This is the functional User Id

UAI:
  Type: String
  Description: This is the App UAI

AppName:
  Type: String
  Description: This is the Application name

ArtifactBucketPath:
  Type: String
  Description: This is S3 Bucket PATH arn

Env:
  Type: String
  Description: This is the Environment for which we are deploying the resource
  
```
### Dependency on Other AWS resources ?
-   None

## History

### iam-user.cf.yml
- Initial Release iam-user.cf.yml

   

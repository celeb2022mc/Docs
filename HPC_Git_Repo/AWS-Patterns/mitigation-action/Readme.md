## Usecase 
- This will allow app team to setup IOT Mitigation actions

## Pre-Requisite
-   Role ARN that is going to be used
-   SNS ARN that is going to be used
## Parameters to pass 

### Sample 

```yaml
  UAI: uai3064620 # Your APP UAI

  AppName: ismail-test # Your app name 
 
  Env: dev # App environment 

  RoleARN: arn:aws:iam::992382426084:role/vn/account-privileged # IAM Role that has been created for the purpose

  TopicARN: arn:aws:sns:us-east-1:992382426084:uai3064620-snstestjay1-qa-my-app1.fifo # SNS Topic that has been created for this purpose

```
### Explanation of Parameters
```
  UAI:
    Type: String
    Description: "Universal Application Identifier(lowercase). Found at https://applications.ge.com"
    AllowedPattern: "uai[0-9]*"
    MinLength: 10


  AppName:
    Type: String
    AllowedPattern: ^[a-z][a-z0-9\._\-]*[a-z0-9]$
    ConstraintDescription: Must contain only lower case letters, digits or -. Min 3 chars. Max 15. Must start with a letter and end with a letter or digit
    MinLength: !!int 3
    MaxLength: !!int 15

  Env:
    Type: String
    Description: Env of the resource.
    Default: dev
    AllowedValues:
    - dev
    - qa
    - prd
    - stg

  RoleARN: 
    Type: String
    Description: ARN of the IAM Role SNS Topic for MITIGATION ACTION
  TopicARN:
    Type: String
    Description: ARN of  SNS Topic for MITIGATION ACTION
```
### Dependency on Other AWS resources ?
-   SNS
-   IAM

## History
-   Initial release

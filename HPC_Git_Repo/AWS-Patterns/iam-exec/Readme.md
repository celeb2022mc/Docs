## Usecase 
- With this , you can create IAM Role

## Pre-Requisite
-   None

## Parameters to pass 


### Sample 
- iam-exec.cf.yml
```yaml

UAI: uai3064620  #Description: The UAI of the application being managed.

AppName: test  #Description: AppName, keep to 15 characters or less.

Env: stg  #Description: This is the Environment for which we are deploying the resource

Service: ec2   #Description: Which service will assume this role ?

TaskRole: false  #Description: true/false. Is this ECS Task Role ?

ExecRole: false  #Description: true/false. Is this ECS Task Exec Role ?


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
    MaxLength: 20
    AllowedPattern: "[a-z0-9\\-]*"
    Description: AppName, keep to 15 characters or less.

  Env:
    Type: String
    Description: Env instance of the resource.
    Default: dev
    AllowedValues:
    - dev
    - qa
    - prd
  Service:
    Type: String
    Description: Which service will assume this role ?
    AllowedValues:
    - lambda
    - ecs-tasks
    - ec2

  TaskRole:
    Type: String
    Description: true/false. Is this ECS Task Role ?
    Default: false
    AllowedValues:
    - true
    - false

  ExecRole:
    Type: String
    Description: true/false. Is this ECS Task Exec Role ?
    Default: false
    AllowedValues:
    - true
    - false
	
```
### Dependency on Other AWS resources ?
-   TaskRole 
-   ExecRole
-   Service

## History

### iam-exec.cf.yml
- Initial Release iam-exec.cf.yml


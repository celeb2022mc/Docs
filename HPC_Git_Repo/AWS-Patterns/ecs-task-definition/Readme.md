## Usecase 
-  With this , you can create ecs-task-definition

## Pre-Requisite

-   The task definition requires container images, which are typically stored in a container registry such as Amazon Elastic Container Registry (ECR) or Docker Hub.

-    SecretManager ARN

## Parameters to pass 

### Sample 
- ecs-task-definition.cf.yml
```yaml

UAI: uai3064620  # This should be your application UAI
  
AppName: ecstasktest # This should be your app name. should be shortened to 7 to 8 characters without any spaces or _ or - or any special characters
 
Env: qa  #Description: This is the Environment for which we are deploying the resource
  
ContainerCpu: 2048  #Description: The number of cpu units used by the task. 1024 is 1 CPU
  
ContainerMemory: 4096  #Description: How much memory in megabytes to give the container

ImageURI: 992382426084.dkr.ecr.us-east-1.amazonaws.com/app-uai3064620-ajecr-dev/ajayecr  #Description: "The image used to start a container.  Ex: repository-url/image"

ContainerPort: 8080  #Description: the port number on which application is running in Docker

SecretARN: arn:aws:secretsmanager:us-east-1:992382426084:secret:app-uai3064620/ajiamuser/dev/credentiials-eVlv42  #Description: SecretManager ARN of the Database which you are trying to connect.

```

### Explanation of Parameters
```
   UAI:
    Type: String
    Description: The UAI of the application being managed.
    ConstraintDescription: The UAI must be valid, but specified as 'uai' followed by 7 digits.
    AllowedPattern: '^uai[0-9]*$'
    MinLength: 10

  Env:
    Type: String
    Description: Env instance of the resource.
    Default: dev
    AllowedValues:
    - dev
    - qa
    - stg
    - prd
  AppName:
    Type: String
    MaxLength: 25
    MinLength: 3
    Description: Name of the application, keep to 15 characters or less
  TaskName:
    Type: String
    Description: Name of the Task Definition, the Value should be same as Appinstance provided to while creating a role
    Default: appserver-task
  ContainerCpu:
    Type: Number
    Default: 2048
    Description: The number of cpu units used by the task. 1024 is 1 CPU
    AllowedValues: [256, 512, 1024, 2048, 4096]
  ContainerMemory:
    Type: Number
    Default: 4096
    Description: How much memory in megabytes to give the container
  ImageURI:
    Type: String
    Description: "The image used to start a container.  Ex: repository-url/image"
  ContainerPort:
    Type: Number
    Default: 8080
    Description: the port number on which application is running in Docker
  SecretARN:
    Type: String
    Description: SecretManager ARN of the Database which you are trying to connect.

```

### Dependency on Other AWS resources ?
-   ECR and SecretManager Should be available

## History

### ecs-task-definition.cf.yml
- Initial ecs-task-definition.cf.yml

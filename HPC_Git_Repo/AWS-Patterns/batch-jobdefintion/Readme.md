## Usecase 
- With this , you can create a batch-jobdefintion 

## Pre-Requisite
<!-- -   This template will only work in the LZ-Connected Account -->
-   You need to have an ECR Image value from your Account

## Parameters to pass 

### Sample 
- batch-jobdefintion.cf.yml
```yaml

  UAI: uai3064620 #Description: The UAI of the application being managed. UAI starting sequence. MUST be in lowercase.
  
  AppName: aj-bjd #Description: 'Which instance of the application. Example: app1. Must be lowercase. Max 15 chars.'
  
  EnvValue: dev #Description: Env instance of the resource.   
  
  JobDefintionName: bjd-n #Description: "Enter a name of the job definition"
  
  Image: 992382426084.dkr.ecr.us-east-1.amazonaws.com/app-uai3064620-ajecr-dev/ajayecr #Description: "Enter ECR Image value" 
  
  Attempts: '2' #Description: "Enter number of times to move a job to the RUNNABLE status." 
  
  Vcpus: '1'  #Description: "Enter number of Vcpus." 
  
  Memory: '8' #Description: "Enter Memory Unit."

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
  
EnvValue:
  Type: String
  Description: Env instance of the resource.   
  AllowedValues:
    - dev
    - qa
    - stg
    - prd
    
JobDefintionName:
  Type: String
  Description: "Enter a name of the job definition"   
  
Image:
  Type: String
  Description: "Enter Image"   
  
Attempts:
  Type: String
  Description: "Enter number of times to move a job to the RUNNABLE status."  
  
Vcpus:
  Type: String
  Description: "Enter number of Vcpus." 
  
Memory:
  Type: String
  Description: "Enter Memory Unit."
```
### Dependency on Other AWS resources ?
-   ECR Image

## History

### batch-jobdefintion.cf.yml
- Initial Release batch-jobdefintion.cf.yml

   

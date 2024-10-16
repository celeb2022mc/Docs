## Usecase 
- With this , you can create a batch-schedulingpolicy

## Pre-Requisite
<!-- -   This template will only work in the LZ-Connected Account -->
- None

## Parameters to pass 

### Sample 
- batch-schedulingpolicy.cf.yml
```yaml

UAI: uai3064620 #Description: The UAI of the application being managed. UAI starting sequence. MUST be in lowercase.

AppName: aj-bjs #Description: 'Which instance of the application. Example: app1. Must be lowercase. Max 15 chars.'

EnvValue: dev #Description: Env instance of the resource.

SchedulingPolicyName: FIFO    #Description: "Enter a name of the scheduling policy"

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
    
SchedulingPolicyName:
  Type: String
  Description: "Enter a name of the scheduling policy"
  ConstraintDescription: Minimum length of 1. Maximum length of 128.
  MinLength: !!int 1
  MaxLength: !!int 128   
```
### Dependency on Other AWS resources ?
-   None 

## History

### batch-schedulingpolicy.cf.yml
- Initial Release batch-schedulingpolicy.cf.yml

   

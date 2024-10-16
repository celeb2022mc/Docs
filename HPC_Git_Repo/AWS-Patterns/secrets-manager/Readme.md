## Usecase 
-  With this , you can create Secrets Manager

## Pre-Requisite
-   This template will work in all kind of accounts 


## Parameters to pass 

### Sample 
- secrets-manager.cf.yml
```yaml

UAI: uai3064620  # This should be your application UAI


AppName: snstestjay1 # This should be your app name. should be shortened to 7 to 8 characters without any spaces or _ or - or any special characters

Env: qa  #Description: This is the Environment for which we are deploying the resource
```
- secrets-manager.v01.cf.yml

```yaml

UAI: uai3064620  # This should be your application UAI


AppName: snstestjay1 # This should be your app name. should be shortened to 7 to 8 characters without any spaces or _ or - or any special characters

Env: qa  #Description: This is the Environment for which we are deploying the resource

AppInstance: rds-secret # The purpose of creating this secrets manager
```

### Explanation of Parameters
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
   
  AppInstance:
    Type: String
    Description: "App Instance for ex: jenkins, app, web "

```

### Dependency on Other AWS resources ?
-   None

## History

### secrets-manager.cf.yml
- Initial Release 

### secrets-manager.v01.cf.yml
- Added one more parameter called AppInstance which will allow app team to create multiple secrets manager

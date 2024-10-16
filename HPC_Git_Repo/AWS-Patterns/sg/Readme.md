## Usecase 
-  With this , you can create security group

## Pre-Requisite
-   This template will work in all kind of accounts 


## Parameters to pass 

### Sample 
- sg.cf.yml
```yaml

UAI: uai3064620  # This should be your application UAI
  
AppName: sgtest # This should be your app name. should be shortened to 7 to 8 characters without any spaces or _ or - or any special characters
 
Env: qa  #Description: This is the Environment for which we are deploying the resource
  
AppInstance: app  #Description: Naming the AppInstance 
  
Role: web   #Description: What is the purpose of this 'tier' of the application - web/app/db/... Must be lowercase.

VPCAlias: us1p #Description: used as an informal or internal descriptor within a particular system

```

### Explanation of Parameters
```
    UAI:
      Type: String
      Description: The UAI of the application being managed.
    AppName:
      Type: String
      MaxLength: 20
      AllowedPattern: "[a-z0-9\\-]*"
      Description: AppName, keep to 15 characters or less.
    AppInstance:
        Type: String
        Description: "Which instance of the application. Example: app1-dev. Must be lowercase. Max 14 chars."
        AllowedPattern: '^[a-z][a-z0-9\._\-]*[a-z0-9]$'
        ConstraintDescription: "Must contain only lower case letters, digits, '.', '_' or '-'. Min 3 chars. Max 14. Must start with a letter and end with a letter or digit"
        MinLength: 3
        # add MaxLength=14 on 11-Sep-2017, so it is consistent with web products
        MaxLength: 14
    Role:
        Type: String
        Description: What is the purpose of this 'tier' of the application - web/app/db/... Must be lowercase.
        ConstraintDescription: Must contain only lower case letters and digits. Min 2 characters.
        MinLength: 2
        AllowedPattern: "[a-z0-9]*"
    Env:
        Type: String
        Default: dev
        #AllowedValues: [ 'dev', 'qa', 'prd' ]
        AllowedValues: [ 'dev', 'qa', 'prd', 'stg', 'lab' ]

    VPCAlias:
        Type: String
        Default: us1p

```

### Dependency on Other AWS resources ?
-   None

## History

### sg.cf.yml
- Initial Release sg.cf.yml

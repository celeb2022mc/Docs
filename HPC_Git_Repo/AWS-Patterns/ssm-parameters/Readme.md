## Usecase 
- With this, you can create ssm-parameters

## Pre-Requisite
-   No Pre-Requisites are required

## Parameters to pass 

### Sample 

```yaml

UAI: uai3064620  # This should be your application UAI

Env: dev # Environment of your application 

ParamName: test # This should be the param name that you are planning to create and it should look like this /app-uai

ParamValue: "" # This should be the param value. You should keep it empty and update with the Privileged Role

```
### Explanation of Parameters
-   ssm-parameters.yml (**DO not use this** )

```
  Param1Value:
    Type: String
    Description: "Param 1 description here"
    Default: 'nil'
```
-   ssm-parameters.v2.cf.yml
```
 #  values we will create in the SSM Parameter Store
  UAI:
    Type: String
    Description: The UAI of the application being managed. UAI starting sequence MUST be in uppercase.
    ConstraintDescription: The UAI must be valid, but specified as 'UAI' in upper case followed by 7 digits
    AllowedPattern: '^uai[0-9]*$'
    MinLength: 10
    MaxLength: 10
  Env:
    Type: String
    AllowedValues: [ 'dev', 'qa', 'prd', 'lab', 'stg' ]

  ParamName:
    Type: String
    Description: "Name of the param. Should start with /app-uai"
    Default: '/app-uai'

  ParamValue:
    Type: String
    Description: "Should be left blank and update from the Console with Privileged role"
    Default: ""

```

### Dependency on Other AWS resources ?
-   No

## History
-   Initial Release

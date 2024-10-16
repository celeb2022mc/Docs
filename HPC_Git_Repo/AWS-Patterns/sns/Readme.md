## Usecase 
-  With this , you can create Simple Notification Service

## Pre-Requisite
-   This template will work in all kind of accounts 


## Parameters to pass 

### Sample 
- sns.cf.yml
```yaml

UAI: uai3064620  # This should be your application UAI


AppName: snstestjay1 # This should be your app name. should be shortened to 7 to 8 characters without any spaces or _ or - or any special characters

Env: qa  #Description: This is the Environment for which we are deploying the resource

TopicType: true  #Description: Queue Type is FIFO


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
    
  Env:
    Type: String
    Description: Env instance of the resource.
    Default: dev
    AllowedValues:
    - dev
    - qa
    - stg
    - prd
   
  TopicType:
    Type: String
    Description: Queue Type is FIFO
    AllowedValues: 
    - true
    - false
    
  SNSTopicName:
    Type: String
    Description: Enter a name for the Amazon SNS topic
    
  SNSTopicDisplayName:
    Type: String
    Description: Enter a display name for the Amazon SNS topic

```

### Dependency on Other AWS resources ?
-   None

## History

### sns.cf.yml
- Initial Release sns.cf.yml

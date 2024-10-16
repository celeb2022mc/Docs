## Usecase 
- With this , you can create a EventBridge template

## Pre-Requisite
-   None

## Parameters to pass 


### Sample 
- eventbridge.cf.yml
```yaml

UAI: uai3064620  #Description: The UAI of the application being managed.

AppName: test  #Description: AppName, keep to 15 characters or less.

Env: stg  #Description: This is the Environment for which we are deploying the resource

EventruleeName:   #Description: Enter a event source name

EventBridgeFunction:  #Description: Enter an ARN number of Lambda function

EventBridgeFunctionID:  #Description: Enter Lambda function ID

EventRuleDescription:  #Description: Enter description

ScheduleExpression:  #Description: Enter description

ScheduleNeeded:  #Description: true/false

TriggerNeeded:  #Description: true/false

EventPattern:   #Description: What Event should trigger this rule?

Source:  #Description:


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
  Env:
    Type: String
    Description: Env instance of the resource.
    Default: dev
    AllowedValues:
    - dev
    - qa
    - stg
    - prd  
  
  EventruleeName:
    Description: Enter a event source name
    Type: String
  EventBridgeFunction:
    Description: Enter an ARN number of Lambda function
    Type: String
  EventBridgeFunctionID:
    Description: Enter Lambda function ID
    Type: String 
  EventRuleDescription:
    Description: Enter description
    Type: String 
  ScheduleExpression:
    Description: Enter description
    Type: String 

  ScheduleNeeded:
    Type: String
    Description: 'true/false'
    AllowedValues:
      - 'true'
      - 'false'

  TriggerNeeded:
    Type: String
    Description: 'true/false'
    AllowedValues:
      - 'true'
      - 'false'

  # EventPattern:
  #   Type: String
  #   Description: What Event should trigger this rule?
  #   Default: '{"source":["aws.sts"],"details":{"eventName":"AssumeRole"},"detail-type": ["AWS API Call via CloudTrail"]}'

  Source:
    Type: CommaDelimitedList
  # Details:
  #   Type: String
    # Type: CommaDelimitedList
  DetailType:
    Type: CommaDelimitedList.
	
```
### Dependency on Other AWS resources ?
-   EventBridgeFunction
-   EventBridgeFunctionID
 

## History

### eventbridge.cf.yml
- Initial Release eventbridge.cf.yml


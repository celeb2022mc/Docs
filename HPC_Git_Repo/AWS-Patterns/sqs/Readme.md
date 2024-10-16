## Usecase 
-  With this , you can create Simple Queue Service

## Pre-Requisite
-   This template will work in all kind of accounts 


## Parameters to pass 

### Sample 
- sqs.cf.yml
```yaml

UAI: uai3064620  # This should be your application UAI
  
AppName: sqstest # This should be your app name. should be shortened to 7 to 8 characters without any spaces or _ or - or any special characters
 
Env: qa  #Description: This is the Environment for which we are deploying the resource
  
QueueType: true  #Description: Queue Type is FIFO
  
QueueNameT: testsqs   #Description: Standard Queue Name

QueueNameDLQ:  #Description: DLQ Queue Name

DelaySeconds: 0  #Description: The time in seconds that the delivery of all messages in the queue will be delayed

KmsDataKeyReusePeriodSeconds: 300  #Description: The length of time in seconds that Amazon SQS can reuse a data key to encrypt or decrypt messages before calling KMS again

MaximumMessageSize: 262144  #Description: The maximum size of a message that can be sent to the queue, in bytes

MessageRetentionPeriod: 345600  #Description: The length of time in seconds that Amazon SQS retains a message

ReceiveMessageWaitTimeSeconds: 0  #Description: The time in seconds for which a ReceiveMessage call will wait for a message to arrive

RedrivePolicyMaxReceiveCount: 3  #Description: The maximum number of times a message is delivered to the source queue before being moved to the dead-letter queue

VisibilityTimeout: 30  #Description: The length of time in seconds that a message received by a worker remains invisible to others


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

  QueueType:
    Type: String
    Description: Queue Type is FIFO
    AllowedValues: 
    - true
    - false

  QueueNameT:   
    Type: String
    Description: Standard Queue Name

  QueueNameDLQ:   
    Type: String
    Description: DLQ Queue Name

  DelaySeconds:
    Type: Number
    Description: The time in seconds that the delivery of all messages in the queue will be delayed
    Default: 0

  KmsDataKeyReusePeriodSeconds:
    Type: Number
    Description: The length of time in seconds that Amazon SQS can reuse a data key to encrypt or decrypt messages before calling KMS again
    Default: 300

  MaximumMessageSize:
    Type: Number
    Description: The maximum size of a message that can be sent to the queue, in bytes
    Default: 262144

  MessageRetentionPeriod:
    Type: Number
    Description: The length of time in seconds that Amazon SQS retains a message
    Default: 345600

  ReceiveMessageWaitTimeSeconds:
    Type: Number
    Description: The time in seconds for which a ReceiveMessage call will wait for a message to arrive
    Default: 0

  RedrivePolicyMaxReceiveCount:
    Type: Number
    Description: The maximum number of times a message is delivered to the source queue before being moved to the dead-letter queue
    Default: 3

  VisibilityTimeout:
    Type: Number
    Description: The length of time in seconds that a message received by a worker remains invisible to others
    Default: 30


```

### Dependency on Other AWS resources ?
-   None

## History

### sqs.cf.yml
- Initial Release sqs.cf.yml

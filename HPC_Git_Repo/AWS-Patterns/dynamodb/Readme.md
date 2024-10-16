## Usecase 
- With this, you can create a dynamodb 

## Pre-Requisite
-   None

## Parameters to pass 

### Sample 
- dynamodb.cf.yml
```yaml

UAI: uai3064620 #Description: Name of the UAI   

AppName: aj-dd  #Description: Name of the application

Env: dev  #Description: Environment of the application

Table: aj-dd-test  #Description: TableName, keep to 15 characters or less.

StreamViewType: KEYS_ONLY  #Description: When an item in the table is modified, StreamViewType determines what information is written to the stream for this table

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

Table:
  Type: String
  MaxLength: 30
  Description: TableName, keep to 15 characters or less.

StreamViewType:
  Type: String
  Description: When an item in the table is modified, StreamViewType determines what information is written to the stream for this table
  AllowedValues:
  - KEYS_ONLY
  - NEW_AND_OLD_IMAGES
  - NEW_IMAGE
  - OLD_IMAGE
```
### Dependency on Other AWS resources ?
-   None 

## History

### dynamodb.cf.yml
- Initial Release dynamodb.cf.yml

   

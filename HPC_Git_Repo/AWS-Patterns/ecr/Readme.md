## Usecase 
- With this , you can create an Elastic Container Registry

## Pre-Requisite
-   None

## Parameters to pass 


### Sample 
- ecr.cf.yml
```yaml

AppName: ajecr  #Description: Name of the application, keep to 15 characters or less
  
UAI: uai3064620  #Description: This is the App UAI

Env: dev  #Description: Env instance of the resource.

RepoName: ajayecr  #Description: "Name of the repo, which gives you unique name if you required multiple repos for same application: such as UAI/appname/AppInstance/env"

```
### Explanation of Parameters
```
AppName:
  Type: String
  MaxLength: 25
  MinLength: 3
  Description: Name of the application, keep to 15 characters or less

UAI:
  Type: String
  Description: The UAI of the application being managed.
  ConstraintDescription: The UAI must be valid, but specified as 'uai' followed by 7 digits.
  AllowedPattern: '^uai[0-9]*$'
  MinLength: 10

Env:
  Type: String
  Description: Env instance of the resource.
  AllowedValues:
  - dev
  - qa
  - stg
  - prd

RepoName:
  Type: String
  MinLength: 3
  Description: "Name of the repo, which gives you unique name if you required multiple repos for same application: such as UAI/appname/AppInstance/env"
```
### Dependency on Other AWS resources ?
-   None 

## History

### ecr.cf.yml
- Initial Release ecr.cf.yml

   

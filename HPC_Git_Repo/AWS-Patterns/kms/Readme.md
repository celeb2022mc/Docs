## Usecase 
- If there is a need to create an KMS Key for the Encryption, this KMS Key template can be used.
- By default many AWS service support AWS KMS Key based encryption and that is the one we should be using for supported services.
- Only in the case of if a AWS service does not support AWS KMS Key based encryption , please discuss with Engineering team and then use this template to create the KMS Key

## Pre-Requisite
-   Discussion with the Engineering team
## Parameters to pass 

### Sample 

```yaml
  UAI: uai3064620 # Should use your app UAI
 
  AppName: ismail-test # Should use your app name

  AppInstance: ismail-test # use case like . web/app/crossaccount . it will make the KMS key identifiable 

  Env: dev # Environment 

```
### Explanation of Parameters
```
  UAI:
    Type: String
    Description: "Universal Application Identifier(lowercase). Found at https://applications.ge.com"
    AllowedPattern: "uai[0-9]*"
    MinLength: 10
    MaxLength: 10

  AppName:
    Type: String
    MaxLength: 20
    AllowedPattern: "[a-z0-9\\-]*"
    Description: AppName, keep to 15 characters or less.

  AppInstance:
    Type: String
    Description: "App Instance for ex: jenkins, app, web "

  Env:
    Type: String
    Description: Env instance of the resource.
    AllowedValues:
    - dev
    - qa
    - prd
```
### Dependency on Other AWS resources ?
-   None

## History
-   Initial Release

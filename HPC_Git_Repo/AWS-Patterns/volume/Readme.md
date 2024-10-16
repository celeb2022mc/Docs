## Usecase 

- With this, you can create ebs volume

## Pre-Requisite
-   No Pre-Requisites are required

## Parameters to pass 

### Sample 

```yaml

UAI: uai3064620  # This should be your application UAI
AppName: Test # This is your app nae
Env: dev # Environment of your application 

AvailabilityZone: us-east-1a

VolumeSize: 50

AppInstance: app

```
### Explanation of Parameters
```
 UAI:

      Type: String
      Description: "Universal Application Identifier(lowercase). Found at https://applications.ge.com"
      AllowedPattern: "uai[0-9]*"
      MinLength: 10
  
  
    AppName:
      Type: String
      MaxLength: 20
      AllowedPattern: "[a-z0-9\\-]*"
      Description: AppName, keep to 15 characters or less.
  
    Env:
      Type: String
      Description: Env instance of the resource.
      Default: dev
      AllowedValues:
      - dev
      - qa
      - prd

    AvailabilityZone:
      Type: String
      AllowedValues: [ us-east-1a, us-east-1b, eu-west-1a , eu-west-1b]
      Description: Which Availability Zone to deploy this instance into?

    VolumeSize:
      Type: String
      Default: '100'
    
    AppInstance:
      Type: String
      Description: "App Instance for ex: jenkins, app, web "
	
```
### Dependency on Other AWS resources ?
-   KmsKeyArn 

## History

### volume.cf.yml
- Initial Release volume.cf.yml



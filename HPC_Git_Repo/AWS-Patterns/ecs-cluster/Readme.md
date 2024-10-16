## Usecase 
- With this , you can create an ECS - Cluster Service

## Pre-Requisite
-   None

## Parameters to pass 


### Sample 
- ecs-cluster.cf.yml
```yaml

AppName: ajecs  #Description: Name of the application, keep to 15 characters or less
  
UAI: uai3064620  #Description: The UAI of the application being managed.
  
Env: dev  #Description: Env instance of the resource.

ClusterInstance: aj-cluster-test  #Description: Application Cluster Instance

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
  Default: dev
  AllowedValues:
  - dev
  - qa
  - stg
  - prd
  
ClusterInstance:
  Type: String
  Description: Application Cluster Instance
```
### Dependency on Other AWS resources ?
-   None 

## History

### ecs-cluster.cf.yml
- Initial Release ecs-cluster.cf.yml

   

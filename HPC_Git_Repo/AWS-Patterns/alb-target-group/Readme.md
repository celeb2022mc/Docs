## Usecase 
- You can create a Target group with this template

## Pre-Requisite
-   Default template can be used without any dependencies. 
-   v0.1 needs two ec2 servers to be in place to use with this template

## Parameters to pass 

### Sample 
- alb-target-group.cf.yml
```yaml

UAI: uai3064620  # This should be your application UAI

AppName: myappname  # This should be your app name. should be shortened to 7 to 8 characters without any spaces or _ or - or any special characters

Env: dev  # This should be dev/qa/stg/prd

TargetGroupProtocol: HTTP
  #Description: Protocol HTTP or HTTPS

TargetGroupPort: 8080
  #Description: 'Provide the Targate group Port'

HealthCheckPath: /lzinfra
  #Description: Path that ALB pings for health check requests

PathName: lzinfra
  #Description: Provide the path name without /. This will help to identify TG for which service

```


- alb-target-group.v0.1.cf.yml
```yaml

UAI: uai3064620  # This should be your application UAI

AppName: myappname  # This should be your app name. should be shortened to 7 to 8 characters without any spaces or _ or - or any special characters

Env: dev  # This should be dev/qa/stg/prd

TargetGroupProtocol: HTTP
  #Description: Protocol HTTP or HTTPS

TargetGroupPort: 8080
  #Description: 'Provide the Targate group Port'

HealthCheckPath: /lzinfra
  #Description: Path that ALB pings for health check requests

PathName: /v1/auth
  #Description: Provide the path name without /. This will help to identify TG for which service

InstanceOne:  < >
  # Description: Id of first instance
InstanceTwo:  < > 
  # Description: IId of second instance     
```
### Explanation of Parameters
####   TargetGroupProtocol
Does your app runs on HTTP or HTTPS protocol ? 
####   TargetGroupPort
Which port your app runs on ? 
####   HealthCheckPath
How do aws  check if the App is up and running ? Curl or resource path to check on server 
####   InstanceOne/InstanceTwo
Two EC2 instances that has to be created and added to the Target group for load balancing
#### PathName
This Helps identify for what purpose the Target group was created.

### Dependency on Other AWS resources ?
#### alb-target-group.cf.yml
- None
#### alb-target-group.v0.1.cf.yml
- 2 EC2 Instance IDs 

## History
### alb-target-group.cf.yml
- Initial Release 
### alb-target-group.v0.1.cf.yml
- Added Two Parameters for supplying EC2 server IDs 
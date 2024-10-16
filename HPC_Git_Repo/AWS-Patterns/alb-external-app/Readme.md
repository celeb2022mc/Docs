## Usecase 
- With this , you can create Application Load Balancer in the External Subnet for External Facing application

## Pre-Requisite
-   This template will only work in the LZ-Connected External Account
-   You need to create an ALB SG or Provide an Existing SG Value from your Account

## Parameters to pass 

### Sample 
- alb-external-app.cf.yml
```yaml

UAI: uai3064620  # This should be your application UAI

AppName: myappname  # This should be your app name. should be shortened to 7 to 8 characters without any spaces or _ or - or any special characters

Env: dev  # This should be dev/qa/stg/prd

SecurityGroupValue: sg-0e5e9ed444c1f5307 #< Need to check within the Account >

TimeoutToUse: 60 # The idle timeout value, in seconds. The valid range is 1-4000 seconds. The default is 60 seconds.

```
- alb-external-app.v0.1.cf.yml
```yaml

UAI: uai3064620  # This should be your application UAI

AppName: myappname  # This should be your app name. should be shortened to 7 to 8 characters without any spaces or _ or - or any special characters

Env: dev  # This should be dev/qa/stg/prd

SecurityGroupValue: sg-0e5e9ed444c1f5307 #< Need to check within the Account >

TimeoutToUse: 60 # The idle timeout value, in seconds. The valid range is 1-4000 seconds. The default is 60 seconds.

```

### Dependency on Other AWS resources ?
-   **Security Group** is required to create the ALB. 

## History

### alb-external-app.cf.yml
- Initial Release alb-external-app.cf.yml

### alb-external-app.v0.1.cf.yml
- Removed unnecessary Parameters **"BucketPath"**
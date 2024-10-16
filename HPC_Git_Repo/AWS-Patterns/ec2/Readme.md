## Usecase 
- With this , you can launch an ec2 instance

## Pre-Requisite
-   This template will only work in the LZ-Connected Account

## Parameters to pass 


### Sample 
- ec2.cf.yml
```yaml

UAI: uai3064620  #Description: This is the App UAI

AppName: ajec2  #Description: This is the Application name

AppInstance: app  #Description: Naming the AppInstance

Env: dev   #Description: This is the Environment for which we are deploying the resource

Platform: Linux  #Description: Defining the platform on which our ec2 will get provisioned

VolumeSize: 50  #Description: Size of disk (GB) to attach

VolumeMount: /dev/sda1  #Description: Mount path of the disk

ServerAMI: ami-01b799c439fd5516a  #Description: server ami-id fetched from the account

Ec2InstanceProfile: ''  #Description: Instance profile for server 

EC2Type: t3.medium  #Description: Instance type to build

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

AppInstance:
  Type: String
  Description: "App Instance for ex: jenkins, app, web "

Env:
  Type: String
  Description: Env instance of the resource.
  AllowedValues:
  - dev
  - qa
  - stg
  - prd  
CTOCloudOpsManaged:
  Type: String
  Default: yes
  Description: Is this Server Managed by CTOCloudOps?
  AllowedValues: [ 'yes', 'no' ]

AppEnvCfgID:
  Type: String
  Description: Please provide App cfg ID and we can find in service-now in your applications env.

Platform:
  Type: String
  Description: Linux/Ubuntu or Windows ?
  AllowedValues:
  - Linux
  - Windows

VolumeSize:
  Type: Number 
  Description: Size of disk (GB) to attach
  Default: 300

VolumeMount:
  Type: String 
  Description: Mount path of the disk

ServerAMI:
  Type: String
  Description: server ami-id

Ec2InstanceProfile:
  Type: String
  Description: Instance profile for server (Name only not ARN or PATH)
  Default: ''

EC2Type:
  Type: String 
  Description: Instance type to build
  Default: t3.medium
  AllowedValues:
    - t3.medium
    - m5.large
    - m5.xlarge
    - m5.2xlarge
```
### Dependency on Other AWS resources ?
-   None 

## History

### ec2.cf.yml
- Initial Release ec2.cf.yml

### ec2.v1.cf.yml
- Added MFA Script as part of the User data . so SA does not need to run it manually.

### ec2.v2.cf.yml
- Added option to provide a sg as input for ha configuration
- Fixed Ubuntu EBS mount option and volume format
   

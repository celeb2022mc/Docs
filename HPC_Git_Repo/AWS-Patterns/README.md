# AWS-Patterns
Contains approved reusable templates and modules

## Fixed in v1.3.8
- Added "dr" as env Allowed Value

## Fixed in v1.3.7
- Added tags are as below :-
  - CTOCloudOpsManaged
  - AppEnvCfgID
  - MaintenanceSchedule

## Fixed in v1.3.6
- Added Patch tags into ec2 jinja Template and created new version of template : static-v3.cf-j2.yml
- Added log bucket for alb-external-app template
- Deleted EC2 and Windows-EC2 Template folder and going forword will use only app-patterns-ec2 for create any instance

## Landing Zone 1.1 Release for vn-builder templates
- Provided Templates for the RDS services
- Removed templates which are not tested against Whitelisting SCP Policy and Depends on other AWS services
- Fixed Ubuntu EC2 Volume format and mount
- Released App Pattern for EC2 . Which will allow following (Jinja Templates)
  - Create Mulitple EC2 with 1 stack
  - Mount Multiple Volume and format
  - Add Security Group Chaining through Security Group Stich template


## Fixed in v1.5
- Lambda Integer --> integer -->number
- eventbridge --> remove Detail field as of now as it does not allow putting an Object as Param through CDK
- Removed Constrain from SG for UAI

## Fixes in v1.4

### Updates :-
- SG UAI :- Lower case 
- Lambda :- Allow building with or without VPC
- EvenrRule :- allow a choice to either go with Schedule or an Event Pattern
- EC2 :- Automatically run the SSM Doc to LDAP Auth. 
       Added PemKey as required param while launching the EC2.
### New Addition
- sg-rules.cf-j2.yml :- allows the app team to create SG Rules based on Jinja 
- iam-user:- can create functional IAM user in AWS and retrive the Accesskey Secret Key from secrets manager
- Added a Template named empty/empty.cf.yml this will allow app teams delete stack resources through stack_master process

## Fixes in v1.3

Fix issue with the Windows Build wrong param name 
Added IP as output parameter of the EC2
Changed the Name param from uai to app-uai

s3-bucket.v0.1.cf :- removed AWSAccountName parameter as it is not used within the template as of now

Remove UAIValue to UAI

EC2 Linux/Ubutnu SSM Automation run


## Fixes in v1.2

Removed 10 Char limit for UAI Field

S3 Removed the KMS and Log bucket configuration

Unified "ServerAMI" variable in Ec2 and Windows 
PropagateTagsToVolumeOnCreation Property added for the EC2

SG Removed Default ingress and egress rules

Added template for the Secrets Manager 

Changed IAM Role path from uai to app-uai

Check for the export name 
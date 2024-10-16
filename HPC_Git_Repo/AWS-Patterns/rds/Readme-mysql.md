## Usecase 
- This will help create an RDS Database. Choose the one that is part of the design

## Pre-Requisite
-   Connected Account
## Parameters to pass 

### Explanation of Parameters MYSQL
```yml
  AppInstance:
    Type: String
    AllowedPattern: ^[a-zA-Z0-9-]*$
    Default: 'MySQLAppInst'
    Description: Input the Application Instance Name. Accepts only lowercase, uppercase, number and hyphen

  Env:
    Type: String
    Default: dev
    AllowedValues:
      - dev
      - qa
      - lab
      - stg
      - prd
    Description: Choose relevant Environment.

  UAI:
    Type: String
    Description: The UAI of the application being managed. UAI starting sequence MUST be in uppercase.
    ConstraintDescription: The UAI must be valid, but specified as 'UAI' in upper case followed by 7 digits
    AllowedPattern: '^uai[0-9]{7}$'
    # Default: ''
    # MinLength: 10
    # MaxLength: 10

  ApplicationCI:
   Type: String
   Description: The Asset ID for the Business Application CI from CMDB (ServiceNow) for this application
   AllowedPattern: '^[0-9]*$'
   Default: '1122334455'
   ConstraintDescription: Value must be exactly 10 digits
   MinLength: 10
   MaxLength: 10

  AdminUserName:
    Type: String
    AllowedPattern: '[a-zA-Z][a-zA-Z0-9]*{15}'
    Description: Master username for the RDS
    Default: 'superuser'

  OwnerSSO:
    Type: String
    Description: SSO of the person who will be the CI owner (in CMDB/ServiceNow) for this new DB instance
    Default: '123456789'
    AllowedPattern: '^[0-9]*$'
    ConstraintDescription: Value must be exactly 9 digits
    MinLength: 9
    MaxLength: 9

  DatabaseName:
    Type: String
    Default: 'mysql01'
    MinLength: 1
    MaxLength: 64
    AllowedPattern: '[a-zA-Z]{1}[a-zA-Z0-9]*{62}'
    Description: The application database that should be created to host application data

  DBInstanceIdentifier:
    Type: String
    Default: 'mysql01'
    MinLength: 4
    MaxLength: 11
    AllowedPattern: '[a-zA-Z][a-zA-Z0-9]*'
    Description: The DB instance identifier is case-insensitive, but is stored as all lowercase (as in "mydbinstance"). Must be 7-11 chars long. First character must be a letter. Can't contain two consecutive hyphens. Can't end with a hyphen.

  DBEngine:
    Type: String
    AllowedValues:
      - 'mysql'
    Description: Choose an appropriate DB Engine.
    Default: mysql

  RDSInstanceClass:
    Type: String
    Default: db.t3.medium
    Description: Choose an appropriate DB Instance type.

  DBEngineVersion:
    Type: String
    Default: '8.0'
    AllowedValues:
      - '8.0'
    Description: MySQL supported versions

  StorageType:
    Type: String
    Default: 'General Purpose'
    AllowedValues:
      - 'General Purpose'
      - 'Provisioned IOPS'
  
  AllocatedStorage:
    Type: Number
    MinValue: 20
    Default: 20
    Description: Specify database storage in GiB. Must be greater than 20GiB for General Purpose and 100 GiB for Provisioned IOPS.
    ConstraintDescription: Must be greater than 20GiB for General Purpose and 100 GiB for Provisioned IOPS.

  #Changes done for add-on DB Service
  ProvisionedIOPS:
    Type: Number
    MinValue: 1000
    Default: 1000
    Description: MySQL supports 1000-80000 IOPS.
    ConstraintDescription: Must be a number greater than 1000.
  
  MultiAZDeployment:
    Description: "Support Multi-AZ for HighAvailability?"
    Type: String
    Default: 'false'
    AllowedValues:
      - 'true'
      - 'false'
    ConstraintDescription: must be true or false.

  ParameterGroup:
    # This parameter is intended for usage when apps require a particular Parameter Group to be set
    # For the BrilliantYOU application, a parameter group shall be manually created, and its name passed to this input
    Type: String
    AllowedPattern: "^[a-zA-Z0-9-]*$"
    ConstraintDescription: Must only consist of letters, digits, and hyphens
    Description: Name of already created parameter group. Leave blank if unknown.
    Default: ''

  OptionGroup:
    # This parameter is intended for usage when apps require a particular Option Group to be set, that 
    # is not part of the Compliance Standards
    Type: String
    AllowedPattern: "^[a-zA-Z0-9-]*$"
    ConstraintDescription: Must only consist of letters, digits, and hyphens
    Description: Name of already created option group. Leave blank if unknown.
    Default: ''

  #Changes done for add-on DB Service
  ConnectionEncryption:
    Type: String
    Default: 'SSL'
    Description: Select SSL to Encrypt a connection to Database.
    AllowedValues:
      - 'SSL'

  SourceSG:
    Type: String
    Default: ''
    AllowedPattern: '^$|^sg-[0-9a-f]*$'
    Description: Optional. Security Group id of the upstream appserver from which to allow incoming traffic. If blank, no app server is allowed incoming traffic. This has to be done with an additional stitch

  KmsKeyId:
    Type: String
    Default: ''
    Description: Optional, ARN of KMSKeyID. If provided by app team, it must have read perms for dba-fed/ db-devops-fed roles and this is must 

  FreeSpaceThreshold:
    Type: Number
    MinValue: 2
    MaxValue: 10 
    Default: 4
    Description: Size (in Bytes) for threshold for storage alarm trigger

  ApplicationSupportEmail:
    Type: String
    Default: 'support@ge.com'
    Description: Email ID of application support where all the alerts will be sent, regarding instance health
    AllowedPattern: '^[a-zA-Z0-9.-_]*@ge.com$'

  CertificateIdentifier:
    Type: String
    Default: rds-ca-rsa4096-g1
    AllowedValues:
      - rds-ca-rsa4096-g1
      - rds-ca-ecc384-g1
      - rds-ca-rsa2048-g1
    Description: Certificates to be used for SSL/TLS communication
```

### Dependency on Other AWS resources ?
- SG


## History

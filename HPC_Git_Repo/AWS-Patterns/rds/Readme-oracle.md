## Usecase 
- This will help create an RDS Database. Choose the one that is part of the design

## Pre-Requisite
-   Connected Account
## Parameters to pass 


### Explanation of Parameters Oracle
```yml
  AppInstance:
    Type: String
    AllowedPattern: '^[a-zA-Z0-9-]*$'
    Default: 'AppInstance01'
    Description: Input the Application Instance Name. Accepts only lowercase, uppercase, number and hyphen

  Env:
    Type: String
    Default: dev
    AllowedValues:
      - 'dev'
      - 'qa'
      - 'lab'
      - 'stg'
      - 'prd'
    Description: Choose relevant Environment.

  UAI:
    Type: String
    # Default: 'uai1122334'
    Description: The UAI of the application being managed. UAI starting sequence MUST be in uppercase. This information is on the Process tab of the Business Application in ServiceNow
    ConstraintDescription: The UAI must be valid, but specified as 'UAI' or 'uai' followed by 7 digits
    AllowedPattern: '^uai[0-9]{7}$'
    # MinLength: 10
    # MaxLength: 10

  ApplicationCI:
   Type: String
   Default: '1122334455'
   Description: The Asset ID for the Business Application CI from CMDB (ServiceNow) for this application
   AllowedPattern: '^[0-9]*$'
   ConstraintDescription: Value must be exactly 10 digits
   MinLength: 10
   MaxLength: 10

  Business:
    Type: String
    Default: 'GasPower'
    AllowedValues:
      - 'GasPower'
      - 'Renewables'
      - 'Nuclear'
      - 'SteamPower'
      - 'PowerConversion'

  Owner:
    Type: String
    Default: '123456789'
    Description: SSO of the person who will be the CI owner (in CMDB/ServiceNow) for this new DB instance
    AllowedPattern: '^[0-9]*$'
    ConstraintDescription: Value must be exactly 9 digits
    MinLength: 9
    MaxLength: 9

  ApplicationSupportEmail:
    Type: String
    Default: 'support@ge.com'
    Description: Email ID of application support where all the alerts will be sent, regarding instance health
    AllowedPattern: '^[a-zA-Z0-9.-_]*@ge.com$'

  AdminUserName:
    Type: String
    AllowedPattern: '[a-zA-Z][a-zA-Z0-9]*{15}'
    Description: Master username for the RDS
    Default: 'adminuser'

  DBInstanceIdentifier:
    Type: String
    MinLength: 5
    MaxLength: 11
    AllowedPattern: '[a-zA-Z][a-zA-Z0-9]*'
    Default: 'dbinstid01'
    Description: The DB instance identifier is case-insensitive, but is stored as all lowercase (as in "mydbinstance"). First character must be a letter. Can't contain two consecutive hyphens. Can't end with a hyphen.

  DBEngine:
    Type: String
    Default: oracle-ee
    AllowedValues:
      - 'oracle-ee'

  DBEngineVersion:
    Type: String
    Description: Oracle Engine Version. Only Major numbers are supported, latest minor versions will be picked uppercase.
    Default: '19'
    AllowedValues:
      - '19'

  OptionGroup:
    # This parameter is intended for usage when apps require a particular Option Group to be set, that 
    # was is not part of the Compliance Standards
    Type: String
    AllowedPattern: "^[a-zA-Z0-9-]*$"
    ConstraintDescription: Must only consist of letters, digits, and hyphens
    Description: Name of already created option group. Leave blank if unknown.
    Default: 'gev-dba-rds-opt-group-oracle-ee-19'

  ConnectionEncryption:
    Type: String
    Default: 'OnlySSL'
    Description: Only SSL Connections are allowed
    AllowedValues:
      - 'OnlySSL'

  DefaultDBSubnet: 
    Default: 'db-subnetgroup'
    Type: String
    AllowedValues:
      - 'db-subnetgroup'

  RDSInstanceClass:
    Type: String
    Default: db.m5.large
    Description: Choose an appropriate DB Instance type. Refer https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Oracle.Concepts.InstanceClasses.html#Oracle.Concepts.InstanceClasses.Supported

  DatabaseName:
    Type: String
    Description: If left blank, then ORCL database will be created. Otherwise use up to 8 alphanumeric lower-case characters.
    Default: 'ORCL'
    MaxLength: 8
    AllowedPattern: '^$|^[a-zA-Z0-9]*$' # '^$|^(?=^[a-z0-9]{6,8}$)^([a-z]){2,3}[0-9]{1,2}([a-z]){3,4}$' # '^$|^[a-zA-Z0-9]*$'

  StorageType:
    Type: String
    Default: General Purpose
    AllowedValues:
      - General Purpose
      - Provisioned IOPS

  AllocatedStorage:
    Type: Number
    MinValue: 20
    Default: 20
    Description: Specify database storage in GiB. Must be equal or greater than 20 for General Purpose and 100 for Provisioned IOPS.
    ConstraintDescription: Must be a number equal or greater than 20 for General Purpose and 100 for Provisioned IOPS.

  ProvisionedIOPS:
    Type: Number
    MinValue: 1000
    Default: 1000
    Description: PostgreSQL supports 1000-80000 IOPS.
    ConstraintDescription: Must be a number greater than 1000.
  
  MultiAZDeployment:
    Description: "Support Multi-AZ for HighAvailability?"
    Type: String
    Default: 'false'
    AllowedValues:
      - 'true'
      - 'false'
    ConstraintDescription: must be true or false.

  SourceSG:
    Type: String
    Default: ''
    AllowedPattern: '^$|^sg-[0-9a-f]*$'
    Description: Optional. Security Group id of the upstream appserver from which to allow incoming traffic. If blank, no app server is allowed incoming traffic. This has to be done with an additional stitch

  KmsKeyId:
    Type: String
    Default: ''
    Description: Optional. If you provide a kms key DB will be encrypted using that key. Else common key for the VPC will be used to Encrypt the DB.

  FreeSpaceThreshold:
    Type: Number
    MinValue: 2
    MaxValue: 10 
    Default: 4
    Description: Size (in Bytes) for threshold for storage alarm trigger

  DatabaseCharSet:
    Type: String
    Description: Database character set name. Check all supported at https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.OracleCharacterSets.html
    Default: 'AL32UTF8'
    AllowedValues:
      - AL32UTF8
      - AR8ISO8859P6
      - AR8MSWIN1256
      - BLT8ISO8859P13
      - BLT8MSWIN1257
      - CL8ISO8859P5
      - CL8MSWIN1251
      - EE8ISO8859P2
      - EL8ISO8859P7
      - EE8MSWIN1250
      - EL8MSWIN1253
      - IW8ISO8859P8
      - IW8MSWIN1255
      - JA16EUC
      - JA16EUCTILDE
      - JA16SJIS
      - JA16SJISTILDE
      - KO16MSWIN949
      - NE8ISO8859P10
      - NEE8ISO8859P4
      - TH8TISASCII
      - TR8MSWIN1254
      - US7ASCII
      - UTF8
      - VN8MSWIN1258
      - WE8ISO8859P1
      - WE8ISO8859P15
      - WE8ISO8859P9
      - WE8MSWIN1252
      - ZHS16GBK
      - ZHT16HKSCS
      - ZHT16MSWIN950
      - ZHT32EUC

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


## History

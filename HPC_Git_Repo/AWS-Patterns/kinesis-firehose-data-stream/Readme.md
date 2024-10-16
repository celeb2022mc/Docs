## Usecase 
- With this , you can create kinesis Firehose

## Pre-Requisite
-   None

## Parameters to pass 


### Sample 
- kinesis-firehose-data-stream.cf.yml
```yaml

UAI: uai3064620  #Description: This is the App UAI

AppName: test  #Description: AppName, keep to 15 characters or less.

Env: stg  #Description: This is the Environment for which we are deploying the resource

DeliveryStreamName: test  #Description: 

KinesisStreamARN: arn:aws:kms:us-east-1:992382426084:key/8e3cb2f9-acbc-41b7-8826-183520758e52  #Description: The Role ARN for Kinesis Data Stream

KinesisStreamRoleArn: arn:aws:iam::992382426084:role/vn/bot-lawgiver  #Description: The Role ARN for Kinesis Data Stream

BucketARN: arn:aws:s3:::cf-templates--1o3vbob1i4ez-us-east-1/template-1719396936042.yaml  #Description: ARN of the Destination S3 Bucket

RoleARN: arn:aws:iam::992382426084:role/vn/bot-lawgiver  #Description: The Role ARN for Kinesis Data Stream

CompressionFormat: UNCOMPRESSED  #Description: Compression Format to use for data in destination bucket

KmsKey: arn:aws:kms:us-east-1:992382426084:key/8e3cb2f9-acbc-41b7-8826-183520758e52  #Description: Kinesis Video Stream uses AWS Key Management Service (KMS) to encrypt your data at rest

LogStreamName: abc  #Description: Name of the CloudWatch Logging Stream

Prefix: abc  #Description: Prefix 

ProcessorsType: test #Description: Processor Type

ProcessorsParameterName: test  #Description:  Processor Type Name

ProcessorsParameterValue: test  #Description: Processor Type Value


```
### Explanation of Parameters
```
UAI:
    Type: String
    Description: The UAI of the application being managed. UAI starting sequence. MUST be in lowercase.
    ConstraintDescription: The UAI must be valid, but specified as uai in lower case followed by 7 digits
    AllowedPattern: ^uai[0-9]*$
    MinLength: !!int 10
    MaxLength: !!int 10

  AppName:
    Type: String
    Description: 'Which instance of the application. Example: app1. Must be lowercase. Max 15 chars.'
    AllowedPattern: ^[a-z][a-z0-9\._\-]*[a-z0-9]$
    ConstraintDescription: Must contain only lower case letters, digits or -. Min 3 chars. Max 15. Must start with a letter and end with a letter or digit
    MinLength: !!int 3
    MaxLength: !!int 15

  Env:
      Type: String
      Description: Env instance of the resource.
      Default: dev
      AllowedValues:
      - dev
      - qa
      - stg
      - prd

  DeliveryStreamName:
    Type: String
    Description: The name to use for the service Kinesis Firehose

  KinesisStreamARN:
    Type: String
    Description: The ARN of the Kinesis Data Stream 

  KinesisStreamRoleArn:
    Type: String
    Description: The Role ARN for Kinesis Data Stream 	


  BucketARN:
    Type: String
    Description: ARN of the Destination S3 Bucket

  RoleARN:
    Type: String
    Description: ARN of the IAM Role

  CompressionFormat:
      Type: String
      Description: Compression Format to use for data in destination bucket
      Default: UNCOMPRESSED
      AllowedValues:
      - GZIP
      - HADOOP_SNAPPY
      - Snappy
      - UNCOMPRESSED
      - ZIP

  KmsKey:
    Type: String
    Description: Kinesis Video Stream uses AWS Key Management Service (KMS) to encrypt your data at rest

  LogStreamName:
    Type: String
    Description: Name of the CloudWatch Logging Stream

  Prefix:
    Type: String
    Description: Prefix


  ProcessorsType:
      Type: String
      Description: Processor Type
      Default: MetadataExtraction
      AllowedValues:
      - AppendDelimiterToRecord
      - Lambda
      - MetadataExtraction
      - RecordDeAggregation

  ProcessorsParameterName:
      Type: String
      Description: Processor Type Name
      Default: MetadataExtractionQuery
      AllowedValues:
      - BufferIntervalInSeconds
      - BufferSizeInMBs
      - Delimiter
      - JsonParsingEngine
      - LambdaArn
      - MetadataExtractionQuery
      - NumberOfRetries
      - RoleArn
      - SubRecordType  

  ProcessorsParameterValue:
      Type: String
      Description: Processor Type Value
      Default: '{YYYY : (.ts/1000) | strftime("%Y"), MM : (.ts/1000)
                | strftime("%m"), DD : (.ts/1000) | strftime("%d"), HH: (.ts/1000)
                | strftime("%H")}' 
```
### Dependency on Other AWS resources ?
-   BucketARN
-   RoleARN
-   KmsKey 

## History

### kinesis-firehose-data-stream.cf.yml
- Initial Release kinesis-firehose-data-stream.cf.yml


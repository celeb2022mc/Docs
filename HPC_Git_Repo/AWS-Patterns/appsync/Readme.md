## Usecase 
- With this, you can create an AWS AppSync API

## Pre-Requisite
-   Lambda function and Service Role Values are a prerequisite for the service

## Parameters to pass 

### Sample 
- appsync.cf.yml
```yaml
UAI: uai3064620 #Description: The UAI of the application being managed. UAI starting sequence. MUST be in lowercase.

AppName: aj-appsync #Description: 'Which instance of the application. Example: app1. Must be lowercase. Max 15 chars.'

EnvValue: dev #Description: Env instance of the resource.

GraphQLApiName: MyGraphQLAPI  #Description: GraphQL Api Name

AppSyncDataSourceName: MyLambdaDataSource #Description: AppSync DataSource Name

LambdaFunctionArnValue: arn:aws:lambda:us-east-1:992382426084:function:uai3064620-lambdatest-web-qa-lambda-role #Description: Enter an arn value of Lambdafunction

ServiceRoleArnValue: arn:aws:iam::992382426084:role/vn/account-privileged #Description: Enter an arn value of ServiceRole

FieldNameValue: getUser  #Description: The GraphQL field on a type that invokes the resolver.  

TypeNameValue: Query #Description: Enter a type value for AppSyncResolver. 

AppSyncDataSourceType: AWS_LAMBDA #Description: The type of the data source.  

AppSyncAuthenticationType: API_KEY #Description: The type of the data source.

ParamSchema: |
  type Query {
    getUser(id: ID!): User
  }
  type User {
    id: ID!
    name: String
    email: String
  }  #Description: The text representation of a GraphQL schema in SDL format.

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
  
EnvValue:
  Type: String
  Description: Env instance of the resource.
  Default: dev
  AllowedValues:
  - dev
  - qa
  - stg
  - prd  
  
GraphQLApiName:
  Type: String
  Description: GraphQL Api Name
  
AppSyncDataSourceName:
  Type: String
  Description: AppSync DataSource Name
  
LambdaFunctionArnValue:
  Type: String
  Description: Enter an arn value of Lambdafunction
  
ServiceRoleArnValue:
  Type: String
  Description: Enter an arn value of ServiceRole
  
FieldNameValue:
  Type: String
  Description: The GraphQL field on a type that invokes the resolver.  
  
TypeNameValue:
  Type: String
  Description: Enter a type value for AppSyncResolver.  
  
AppSyncDataSourceType:
  Type: String
  Description: The type of the data source.    
  AllowedValues:
  - AWS_LAMBDA
  - AMAZON_DYNAMODB
  - AMAZON_ELASTICSEARCH
  - AMAZON_OPENSEARCH_SERVICE
  - NONE
  - HTTP
  - RELATIONAL_DATABASE
  
AppSyncAuthenticationType:
  Type: String
  Description: The type of the data source.    
  AllowedValues:
  - API_KEY
  - AMAZON_COGNITO_USER_POOLS
  - OPENID_CONNECT
  - AWS_LAMBDA 
  
ParamSchema:
  Type: String
  Description: The text representation of a GraphQL schema in SDL format.
```
### Dependency on Other AWS resources ?
-   Lambda function and Service Role 

## History

### appsync.cf.yml
- Initial Release appsync.cf.yml

   

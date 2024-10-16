## Usecase 
-  With this , you can create SES Email Identity

## Pre-Requisite
-   This template will work in all kind of accounts 


## Parameters to pass 


### Sample 
- ses.cf.yml
```yaml


UAI: uai3064620  #Description: The UAI of the application being managed.

AppName: test  #Description: AppName, keep to 15 characters or less.

Env: stg  #Description: This is the Environment for which we are deploying the resource

Email: "bala.donat@ge.com"  #Description: Enter Email Address

ConfigurationSetName: "test_config"  #Description: 

HtmlPart: "<h1>Hello,</h1><p>html sample</p>"  #Description: The HTML body of the email.

SubjectPart: "subject"  #Description: The name to use for the service SES ConfigurationSet

TemplateName: "example"  #Description: The name of the template.

TextPart: "example"  #Description: The email body that is visible to recipients whose email clients do not display HTML content.


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
  
  Email:
    Type: String
    Description: Enter Email Address
    
  ConfigurationSetName:
    Type: String
    Description: The name to use for the service SES ConfigurationSet
   
  HtmlPart:
    Type: String
    Description: The HTML body of the email.
  
  SubjectPart:
    Type: String
    Description: The subject line of the email.
    
  TemplateName:
    Type: String
    Description: The name of the template.
    
  TextPart:
    Type: String
    Description: The email body that is visible to recipients whose email clients do not display HTML content.
	
```
### Dependency on Other AWS resources ?
-   None 



## History

### ses.cf.yml
- Initial Release ses.cf.yml


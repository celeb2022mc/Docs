## application-template
For more Information ,Check out :- https://github.build.ge.com/vernova-cloud-iac/Sample-Application

Doc :- https://hosting.vncloudapp.io/docs/landingzone/infra-processor

AWS Pattern latest Release : https://github.build.ge.com/vernova-cloud-iac/AWS-Patterns/releases

> **Note:-** AWS Pattern Release has all templates of AWS Resources, Before creating any AWS Resource please go through README file of particular resource template.

## Resource creation setup 
Template resource creation setup works primarily with the two files:

1. manifest.yml- This file has details on the AWS account in use, account number and the infra template release version. In an ideal production build scenario. this file must not be changed/edited.
2. stack_input_dev.yml- This file has the property and actual redirection for stacks to look up the CFT template to build the resources that need to be built.

# application-template
For more Information ,Check out :- https://github.build.ge.com/vernova-cloud-iac/Sample-Application
Doc :- https://hosting.vncloudapp.io/docs/landingzone/infra-processor
AWS Pattern latest Release : https://github.build.ge.com/vernova-cloud-iac/AWS-Patterns/releases

## Stack Deletion Process
Now Team can delete stack as well. For this we are providing "AWS Stack Delete" job under Actions for every Application.

Steps are :
1. Click on Actions.
2. Click on "AWS stack Delete"
3. Click on Run Workflow
3. Select branch parameter "dev or prd"
4. Pass "stack_name" and run

> **Note 1:-** We can pass mulitpe stack_name via space seperater. Ex : stack_1 stack_2

> **Note 2:-** Old application which doesn't have this stack deletion pipeline they can add this file : https://github.build.ge.com/vernova-cloud-iac/application-template-aws/blob/dev/.github/workflows/stack_delete.yml inside .github/workflows folder.
Note : We can pass mulitpe stack_name via space seperater. Ex : stack_1 stack_2

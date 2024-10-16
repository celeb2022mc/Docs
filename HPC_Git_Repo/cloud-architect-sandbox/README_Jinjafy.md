## Jinjafy Template

Jinja is a text templating language. It allows you to process a block of text, insert values from a context dictionary, control how the text flows using conditionals and loops, modify inserted data with filters, and compose different templates together using inheritance and inclusion.

It Provides Some key functionality not pesent in CLoudFormation :
1. Include statements to insert code from separate files, inline in the main code file.
2. Looping statements, to allow creation of multiple repeating resources, without writing out similar code multiple times.
3. Conditionals, to allow logic that includes, excludes, or alters resources based on previous configuration parameters.

## Components
Jinja Template infra builder setup works primarily with the two files:

1. manifest.yml- This file has details on the AWS account in use, account number and the infra template release version. In an ideal production build scenario. this file must not be changed/edited.
2. stack_input_dev.yml- This file has the property and actual redirection for stacks to look up the CFT template to build the resources that need to be built (in the base AWS EC2 example, it is static-v2.cf-j2.yml)

## Sample stack_input_dev.yml

[stack_input_dev.yml](https://github.build.ge.com/vernova-cloud-iac/cloud-architect-sandbox/blob/jinjafy-template/AWS-LINUX-JINJAFY-VM/samples/stack_input_dev.yml)

**NOTE :-**

In Jinja Template Resource parameters mention in stack file itself. While process Jijnja templete it use to create "Paramerter file/Template file/Stack master" file but this is all backend process.


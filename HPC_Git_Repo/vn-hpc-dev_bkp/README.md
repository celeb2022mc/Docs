# vn-hpc-dev - Account ID 445567079976

This repository contains the IaC for AWS account "vn-hpc-dev". It comes pre-packaged with the landing zone configurations that were run on account setup. To add additional resources to this account, create a new branch, write a CloudFormation template and parameters (if needed), and reference it with master.yml. Once your PR is merged into main, the Infra Processor will start and run your CloudFormation templates.

The Infra Processor will run `ansible-playbook`. To test locally do something like:
```bash
pip install ansible
ansible-playbook playbook.yaml -e @master.yml -vv
```

Content of [master.yml](./master.yml) has to contain a variable `master_vars`, which is an array of items

Each item contains the following attributes:
- [required] `task_description`: Ansible description for task
- [required] `stack_name`: Name of CloudFormation stack
- [required] `template`: Path to CloudFormation template
- [optional] `template_parameters`: Path to CloudFormation template parameters file
- [optional] `params`: inline parameters values

if `params` are specified they 'win' over `template_parameters`

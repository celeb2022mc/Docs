
<div class="image-container">
<div class="md-image">
<img src="../images/ec2-ha.png" height="50px" width="50px">
</div>
</div>

<span class="markdown-text">

## EC2 Template
   - **Linux/Windows**: [static-v2.cf-j2.yml](https://github.build.ge.com/vernova-cloud-iac/AWS-Patterns/blob/main/app-patterns-ec2/static-v2.cf-j2.yml)
   - **Linux/Windows**: [static-v3.cf-j2.yml](https://github.build.ge.com/vernova-cloud-iac/AWS-Patterns/blob/main/app-patterns-ec2/static-v3.cf-j2.yml)

This component can be used to create one or more Linux or Windows EC2 instances with multiple (optional) EBS volumes.
Additionally the following optional resources can be added:
* an ALB to load balance between the EC2 instances


## Inputs
**jinjaparams:** - see [example](#jinjaparams-example) below
 * **InstancesCount**: (required) Specify how many instances would you like to create
 * **Alb** : (optional) Specify 'true' to create an ALB. If you specify 'false' all parameters starting with LB are ignored
 * **ExtraVolumes**: Array of objects for each EBS volume you want to have. Each object can have the following properties:
   * **size:**  (required) Size of the EBS volume
   * **mount:** (required) The local directory under which the EBS volume will be mounted. Ex: /data
   * **device:** (required) You must specify a unique device name for each volume. Something like /dev/xvdk, /dev/xvdl, /dev/xvdm, /dev/xvdn
   * **type:** (optional) Default to gp2,  Allowed values are standard, gp2, st1, io1, sc1
   * **iops:** (optional) How many IOPS? Valid only for EBS Type io1.
   *  **snapshot** : (optional) Specify the ID of the snapshot from which to create the volume

## Inputs

* **UAI** and **AppInstance**: as these are always required. See [required-inputs-to-identify-app](../GUIDELINES.md#required-inputs-to-identify-app)
* **Env**: used for tagging and drives backup policy; backup will be 35 days if Env=prd, otherwise it will be 7 days
* **Role**: Logical role for this tier. Must be unique within the app/UAI. Limited to 3 characters only. Example: app, web, ap2, etc.
* **RoleType**: Determines in which subnet will resources be created. Specify one of 'frontend', 'backend', 'auth-on-app'. See use cases below for more info
* **Platform**: Determines in which Type of OS it will be created. Specify one of 'Linux', OR 'Windows'
* **CTOCloudOpsManaged**: Is this Server Managed by CTOCloudOps? Default value is "yes"
* **AppEnvCfgID**: [Mandatory Property] Please provide App cfg ID and we can find in service-now in your applications env.



### Application LoadBalancer Section

* **LBPlainHTTPListenerBehaviour** : What frontend plain HTTP ALB listener (on port 80) to create
  - forward - send the plain HTTP traffic to the backend
  - redirect - redirect HTTP to HTTPS from the ALB
* **LBHealthCheckFilePath** : Path to a resource served by your application to ensure the ALB is able to determine the health of the app. Default is /healthcheck/monitor.html
* **LBExposedPort** : Port used for inbound traffic of the ALB (443 or 8443, could be 80)
* **LBExposedURLSSLCertARN** : Specify the ACM ARN for the SSL cert to assign to the ALB. Typically you want stack_master to look this up using the name of the domain. App tier might use the self-signed SSL cert we maintain with something like ``` acm_certificate: self-signed-mc.cloud.ge.com ```
* **LBBackendProtocol** : Protocol used (HTTP or HTTPS) from the ALB to EC2 server. HTTPS is highly recommended (and the default)
* **LBBackendPort** : Port used to accept traffic to the web application from the ALB (443 or 8443 in most cases)
* **LBEnableHTTP2**:  Specify whether it is an true or false . The default is true.
* **Scheme**:  Specify whether it is internet-facing or internal . The default is internal.

### ALB stickiness

* **LBEnableLBCookieStickiness** : If you specify 'yes' the frontend ALB will generate a 'stickiness' cookie to track the same user session to always be sent to the same backend (Default: no)
* **LBCustomCookieName** : Specify the name of the cookie name which your application server generates(e.g. JSESSION). The default is an empty string, which will use an AWS generated cookie
* **LBStickinessLBCookieDurationSeconds** : The time period, in seconds, during which requests from a client should be routed to the same target. After this time period expires, the load balancer-generated cookie is considered stale. The range is 1 second to 1 week (604800 seconds) (Default: 86400)
* **LBStickinessDeregistrationDelayTimeoutSeconds** : The duration before ALB stops sending requests to targets that are de-registering (Default: 300)
* **LBStickinessSlowStartDurationSeconds** : Time for the target to warm up before it is allowed to start receiving requests from the ALB (Default: 300)
* **UseImpervaWAF** : Set to 'yes' to allow only HTTPS traffic only from Imperva WAF networks. Applies when RoleType=frontend. Specifying 'yes' in a standard/connected account will result in an error
* **AttachAWSWAF** : Set to 'no' when you do not want to attach the AWS managed WAF web ACL. Keep in mind this will NOT remove an existing web ACL association. Specifying 'yes' in a limited/external account is not allowed (has no effect)

### EC2 Instance

* **InstanceType**  : Type of EC2 : t2.medium, m3.medium, m4.large, c4.large, m4.xlarge, m4.2xlarge, c5.large, c5.xlarge, m5.large, m5.xlarge
* **CustomAMI** : Use this to specify a custom (project specific) AMI
* **UpDownSchedule**: This represents the create and terminate schedule for EC2 instance
  - Format looks like ```U(<cron expression>)D(<cron expression>)```. Please see details at [required UpDownSchedule format](../UpDownSchedule-Format)
  - This parameter is optional. If no value is provided (empty string):
		- **env=prd** will not be enforced a schedule - it will run all the time
		- **non-prod** a default schedule will be enforced depending on the time zone. See the [exceptions section](../UpDownSchedule-Format.md#exceptions) for more details
  - You can specify the value 'None' to explicitly not set a schedule even in non-prod env. In this case the instances will run 24/7
  - Instances can be created or terminated only in the middle of the hour (6:30 AM, 7:30 AM or PM, etc.) we forced this setting due to RDS billing to generate more savings
* **AppServerAccessGroup**: Specify the Access group Name. For WINDOWS: Specify the name of the AD group; For Linux: specify the name of an existing LDAP netgroup
* **InstancePlacementGroup** : (Optional)  Specify the name of an existing Placement Group where to start the instance. You need to comply with the limitations of which instance type can use this as described in http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html
* **CommonSG** : (Optional) Specify an existing 'common' SG to assign to your app server.
* **TierSG**:  (Optional) Specify an existing 'tier' SG to assing to your app server.
* **CreateOwnSG**: Specify 'no' if you don't want an 'application specific' SG to be created. By default a new SG is created (the default value is 'yes')
* **StaticIP**: (optional) Assign a static IP to this instance?


### Application-Specific
* **InstanceProfile** : by default the IAM role/profile assign to EC2 is ssm-managed-profile, you can use a custom IAM role defined with the [EC2 Instance Profile component](../iam-profile)
* **COS** : Specify which operating system AMI to use
  - Allowed values for Linux: CENTOS7, RHEL7
  - Allowed values for Windows: Windows2012R2, Windows2016, Windows2019

## Outputs

* **EC2StdSG** : The standard security group

## Use cases


| Use Case                                                  	| Configuration                              	| Special Inputs                                                                                                                                                                                                                                                                                                                                                                                                                     	| Sample Infradef                   	|
|-----------------------------------------------------------	|--------------------------------------------	|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|-----------------------------------	|
| Application   server with EBS but without load balancing               	| EC2 instances in app subnet                	| Role: lx or win<br>     RoleType: backend                                                                                                                                                                                                                                                                                                                                                                                          	| [Static-1](#static-1) 	|
| Application   server with load balancing                  	| EC2+ALB in app subnet                      	| Role: lx <br>     RoleType: backend<br>     ________<br>     LBExposedPort: 8080 or 8443 if invoked from auth subnet<br>     LBBackendPort: running app specific port<br>     ________<br>     LBBackendProtocol:  'HTTP' <br>     or <br>     LBBackendProtocol: 'HTTPS'<br>     LBExposedURLSSLCertARN: `<certificate arn>`                                                                                                        	| [Static-2](#static-2) 	|

### jinjaparams example
InstancesCount and Extravolumes may be added using jinja parameters. See example below

```yaml
      jinjaparams:
        InstancesCount: 2
        ExtraVolumes:
          - mount: /data
            size: 20
            device: /dev/xvdk
          - mount: /data1
            size: 40
            device: /dev/xvdl
            snapshot: snap-0e36ecf3363a974c7
```

* **cfn logs** : whenever stack fails after creating the instance, the logs will be uploaded to the S3 artifacts bucket.
* **Instance Replacement** : when we update the template with the AMI or InstanceType, Instance will be replaced. Instance will be replaced if the value for AppDeploymentVersion changes

## Static-1
```yaml
## This infra definition file will create Web server without load balancing in connected accounts
#template_dir: /usr/local/app/ManagedComponents-Nexus/ManagedComponents
# template_dir: .

common:
  UAI: uai3064620
  ENV: dev
  VPCALIAS: gr-ttp
  SSO: 204056024
  APPNAME: 'infra'
  APP_INSTANCE: 'dev'
  AWS_ACCOUNT: 'cto-architecture-sandbox'


#Python script will replace the values for uai, env and Builder
stack_defaults:
  tags:
    uai: uai3064620
    env: dev
    Builder: vn-builder
    Life: good
  s3:
    bucket: app-uai3064620-landing-zone-dev-s3-lz10
    prefix: deploy-artifacts/uai3064620/test
    region: us-east-1


region_aliases:
  us1: us-east-1

stacks:
  us1:

    # *******************************************
    # create ec2s Resources with Jinja Template
    # *******************************************

    ec2-lx-1:
      template: ../AWS-Patterns/app-patterns-ec2/static-v2.cf-j2.yml
      params:
        #Common
        UAI: { "common": "UAI" }
        AppName: { "common": "APPNAME" }
        AppInstance: wfbldr1
        Env: { "common": "ENV" }
        Platform: Linux
        #VPCAlias: { "common": "VPCALIAS"}
        #Basic
        CustomAMI: # ami-0287656f6c0c09b8f
          latest_ami:
            owners: '057064532517'
            filters:
              name: GESOS-AWS-BASE_ORACLELINUX8*
        InstanceProfile: vn-default-ssm-access-profile
        InstanceType: t3.medium
        Role: lx
        RoleType: backend
        COS: OEL8
        AppServerAccessGroup: 'CA_AWSENTC_NC_CO_MC_PREPROD'
      jinjaparams:
        InstancesCount: 1 #Can pass n number of instance
        Alb: false
        ExtraVolumes:
          - mount: /data
            size: 10
            device: /dev/xvdk
          - mount: /data    #Can add more than one EBS block
            size: 15
            device: /dev/xvdm
            
    ec2-win-1:
      #template: ../AWS-Patterns/ec2/ec2.v2.cf.yml
      template: templates/ec2-custom/static-v2.cf-j2.yml
      params:
        UAI: { "common": "UAI" }
        AppName: { "common": "APPNAME" }
        AppInstance: wfbldr1
        Env: { "common": "ENV" }
        Platform: Windows
        #VPCAlias: { "common": "VPCALIAS"}
        CustomAMI: # ami-0287656f6c0c09b8f
          latest_ami:
            owners: '057064532517'
            filters:
              name: GESOS-AWS-BASE_Windows2019*
        InstanceProfile: vn-default-ssm-access-profile
        #InstanceType: t3.medium
        Role: win
        RoleType: backend
        #FQDN: 'test.test.com'
        COS: Windows2019
        AppServerAccessGroup: 'SVR_GE003000000_venuWinTestApp'
      jinjaparams:
        InstancesCount: 1  #Can pass n number of instance
        Alb: false
        ExtraVolumes:
          - mount: /data
            size: 30
            device: /dev/xvdk
          - mount: /data  #Can add more than one EBS block
            size: 15
            device: /dev/xvdm
```

## Static-2
```yaml
## This infra definition file will create Application server with load balancing
#template_dir: /usr/local/app/ManagedComponents-Nexus/ManagedComponents
# template_dir: .

common:
  UAI: uai3064620
  ENV: dev
  VPCALIAS: gr-ttp
  SSO: 204056024
  APPNAME: 'infra'
  APP_INSTANCE: 'dev'
  AWS_ACCOUNT: 'cto-architecture-sandbox'


#Python script will replace the values for uai, env and Builder
stack_defaults:
  tags:
    uai: uai3064620
    env: dev
    Builder: vn-builder
    Life: good
  s3:
    bucket: app-uai3064620-landing-zone-dev-s3-lz10
    prefix: deploy-artifacts/uai3064620/test
    region: us-east-1


region_aliases:
  us1: us-east-1

stacks:
  us1:

    # *******************************************
    # create ec2s Resources with Jinja Template
    # *******************************************

    ec2-lx-1:
      template: ../AWS-Patterns/app-patterns-ec2/static-v2.cf-j2.yml
      params:
        #Common
        UAI: { "common": "UAI" }
        AppName: { "common": "APPNAME" }
        AppInstance: wfbldr1
        Env: { "common": "ENV" }
        Platform: Linux
        #VPCAlias: { "common": "VPCALIAS"}
        #Basic
        CustomAMI: # ami-0287656f6c0c09b8f
          latest_ami:
            owners: '057064532517'
            filters:
              name: GESOS-AWS-BASE_ORACLELINUX8*
        InstanceProfile: vn-default-ssm-access-profile
        InstanceType: t3.medium
        Role: lx
        RoleType: backend
        COS: OEL8
        AppServerAccessGroup: 'CA_AWSENTC_NC_CO_MC_PREPROD'
        #ALB Parameters
        LBExposedPort: 443
        LBBackendPort: 443
        LBBackendProtocol: HTTPS
        #LBExposedURLSSLCertARN:
        #  acm_certificate: 'test.test.com'
        #LBPlainHTTPListenerBehaviour: forward
      jinjaparams:
        InstancesCount: 1 #Can pass n number of instance
        Alb: true
        ExtraVolumes:  #Can add more than one EBS block
          - mount: /data
            size: 10
            device: /dev/xvdk

    ec2-win-1:
      #template: ../AWS-Patterns/ec2/ec2.v2.cf.yml
      template: templates/ec2-custom/static-v2.cf-j2.yml
      params:
        UAI: { "common": "UAI" }
        AppName: { "common": "APPNAME" }
        AppInstance: wfbldr1
        Env: { "common": "ENV" }
        Platform: Windows
        #VPCAlias: { "common": "VPCALIAS"}
        CustomAMI: # ami-0287656f6c0c09b8f
          latest_ami:
            owners: '057064532517'
            filters:
              name: GESOS-AWS-BASE_Windows2019*
        InstanceProfile: vn-default-ssm-access-profile
        #InstanceType: t3.medium
        Role: win
        RoleType: backend
        #FQDN: 'test.test.com'
        COS: Windows2019
        AppServerAccessGroup: 'SVR_GE003000000_venuWinTestApp'
        #ALB Parameters
        LBExposedPort: 443
        LBBackendPort: 443
        LBBackendProtocol: HTTPS
      jinjaparams:
        InstancesCount: 1  #Can pass n number of instance
        Alb: false
        ExtraVolumes:
          - mount: /data
            size: 30
            device: /dev/xvdk
          - mount: /data  #Can add more than one EBS block
            size: 15
            device: /dev/xvdm
```


</span>

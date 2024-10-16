## Usecase 
- You can create Appmesh Configuration

## Pre-Requisite
-   Default template can be used without any dependencies. 

## Parameters to pass 

### Sample 
- appmesh.cf.yml
```yaml

UAI: uai3064620  # This should be your application UAI

AppName: myappname  # This should be your app name. should be shortened to 7 to 8 characters without any spaces or _ or - or any special characters

Env: dev  # This should be dev/qa/stg/prd

MeshName: aj-appmesh # name of the appmesh

VirtualNodeName: vn-n #name of the virtual node 

VirtualServiceName: vn-s # name of the virtual service 

VirtualRouterName: vn-r # Name of the virtual router

RouteName: aj-router  # name of the router

ServicesDomain: default.svc.cluster.local # Service domain you wants to use for the AppMesh

Protocol: http  # Protocol . http/http2. http2 is preferred  

ListenersPort: 8080 # port on which your service will listen
  
Path: / # Path for the Heathcheck 

HealthyThreshold: "3" # How many time prob before marking success

UnhealthyThreshold: "2" # how many time to prob before failing

RouterPort: "8080" # Router port to be used

```

### Explanation of Parameters

#### MeshName: 
This is the name of your mesh

#### VirtualNodeName:
This is your virtual node name

#### VirtualServiceName: 
This is name of your virtual service

#### VirtualRouterName: 
This is name of your virtual router

#### RouteName: 
This is name of your Router 

#### ServicesDomain: 
Name of the service domain you wants to use

#### Protocol: 
which protocol to be used? http or http2 

#### ListenersPort: 
service port where service listens to
  
#### Path: 
Path of Healthcheck

#### HealthyThreshold: 
How many time prob before marking success

#### UnhealthyThreshold: 
how many time to prob before failing

#### RouterPort: "8080" 
Router port to be used


### Dependency on Other AWS resources ?
### appmesh.cf.yml
- None

## History
### appmesh.cf.yml
- Initial Release 

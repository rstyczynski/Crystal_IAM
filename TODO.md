
# Policy templates
PT51|Update service access for vulnerability-scanning-service  (after CIS LZ)
PT52|Update service access for osms (after CIS LZ)
PT53|Update service access for streaming (after CIS LZ)
PT60|Add vulnerability-scanning-service to policy profile
PT70|Add OSMS to policy profile
PT90|Fine tune Cloud Guard template
PT91|Extend Cloud Guard for Certificates, Data Safe, and Threat Intelligence 
PT92|Extend Cloud Guard for Certificates, Data Safe, and Threat Intelligence 
PT93|Extend Cloud Guard for Certificates, Data Safe, and Threat Intelligence 
PT110|Externalize Cloud Guard OCI Responders 
PT120|Support for network sources
PT130|Support for tenancy level user group access statements 
PT140|


## low priority
PT54|Update service access for Fssoc4Prod (after CIS LZ)
PT100|Add ORM to policy profile

# Modeling
M30|Define grammar for Crystal@AIM policy statement (CPS). Having this spreadsheet will be converted to CPS, and logic will convert it to final statements using templates.
M40|

# Logic
L10|Move bash code to proper style with command line arguments, error handling, etc.
L40|Optimize number of policy statements by collecting together policies attached at the same level
L50|

# Done
M20|Access policies are attached to compartments, if needed|Available from spreadsheet v6
L20|Generated policies are written to timestamp directory under specified destination directory
L30|Verify provided privilege codes
PT20|Add support for Network Path Analyzer
PT10|Policy statements required by services are available in templates
PT50|Update service access for services (after CIS LZ)
PT80|Add "define tenancy usage-report..." to cost management policies
PT30|Remove Administrators and self group from GROUP administrator rights (after CIS LZ)
PT40|Remove 'AddIdpGroupMapping' and 'DeleteIdpGroupMapping' request.operation from identity-providers administrator rights (after CIS LZ)

# Rejected
M10|Policy statements required by services are handled by the spreadsheet| No need do have it in spreadsheet. Each time resource is used tenancy level statements must be added.

# Implementation notes

## MM20|Access policies are attached to compartments, if needed

### Documentation
https://docs.oracle.com/en-us/iaas/Content/Identity/policiesgs/overview_topic-Example_Scenario.htm#Example

### Parameters
attached_at - parameter where to attach processed policy. This parameter is specified in first column right after group name with header "attach at compartment"

### Default values
attached_at - tenancy

### Special cases
10. attach compartment name must be present if it's the final location
20. attach compartment name must be removed from location's prefix in target policy statement, if more compartments are present in the path

### Errors
10. location prefix does not match ${attached_at}, but permission is specified.

## L20|Generated policies are written to timestamp directory under specified destination directory

### Parameters 
out_timestamp - controls is timestamp should be added

### Default values
out_timestamp - yes

## M30|Define grammar for Crystal@AIM policy statement (CPS). Having this spreadsheet will be converted to CPS, and logic will convert it to final statements using templates.

allow group network_admin to admin local_network in compartment network /*attach at network */

allow group governance_admin to admin iam_tag-namespaces in tenancy having parameter1=abc

## PT20|Add support for Network Path Analyzer

### Documentation
https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/path_analyzer.htm

### access policy
allow group <group-name> to manage vn-path-analyzer-test in tenancy 

### service level access policy
allow any-user to inspect compartments in tenancy where all { request.principal.type = 'vnpa-service' }
allow any-user to read instances in tenancy where all { request.principal.type = 'vnpa-service' }
allow any-user to read virtual-network-family in tenancy where all { request.principal.type = 'vnpa-service' }
allow any-user to read load-balancers in tenancy where all { request.principal.type = 'vnpa-service' }
allow any-user to read network-security-group in tenancy where all { request.principal.type = 'vnpa-service' } 


## PT50|Update service access for services (after CIS LZ)

### service level access policy
Allow service vulnerability-scanning-service to manage instances in tenancy
Allow service vulnerability-scanning-service to read repos in tenancy
Allow service vulnerability-scanning-service to read vnic-attachments in tenancy
Allow service vulnerability-scanning-service to read vnics in tenancy
Allow service vulnerability-scanning-service to read compartments in tenancy

Allow service osms to read instances in tenancy

OK Allow service cloudguard to read all-resources in tenancy
OK Allow service cloudguard to use network-security-groups in tenancy

OK Allow service objectstorage-uk-london-1 to use keys in compartment security-cmp

Allow service (ok) blockstorage, (ok) oke, streaming, Fssoc4Prod to use keys in compartment security-cmp

## PT100|Fine tune Cloud Guard template

### Documentation
https://docs.public.oneportal.content.oci.oraclecloud.com/en-us/iaas/cloud-guard/using/prerequisites.htm#prerequisites

## PT60|Add vulnerability-scanning-service to policy profile

### Documentation
https://docs.oracle.com/en-us/iaas/scanning/using/iam-policies.htm#iam_policies

## PT90|Fine tune Cloud Guard template

### Notes
OCI Cloud Guard is operated under following use cases:
1. Manager to enable Cloud Guard
2. Administrator to configure targets, detectors, managed-lists, and responders
3. Operator to work with problems i.e. mark as resolved, dismiss, and threat monitoring
4. Operator to work with problems to remediate, and responder activities to execute, or skip build-in actions.

Each of the use case requires different set of access statements for users, and cloudguard service itself. CloudGuard may operate on tenancy or compartment level, what means that it's possible to configure user with access privileges to control specific compartment only. 

#### Manage
Manage privilege is always a super power level to do all with the service. This level should be used only by a break glass user during initial tenancy configuration to enable CloudGuard. Manage is used to configure data masking, as exact resource name for this feature is unknown.

```
allow group breakglass to manage cloud-guard-family in tenancy
```

#### Administrator
Administrator privilege gives ability to configure CloudGuard: setup targets, setup managed list;  clone, enable, and configure detectors; clone, enable, and configure responders.

```
allow group cg-admins to manage cloud-guard-targets in $LOCATION
allow group cg-admins to manage cloud-guard-managed-lists in $LOCATION
allow group cg-admins to manage cloud-guard-detector-recipes in $LOCATION
allow group cg-admins to manage cloud-guard-responder-recipes in $LOCATION

allow group cg-admins to inspect cloud-guard-family in $LOCATION
allow group cg-admins to inspect cloud-guard-config in tenancy
```

#### Operator
Operator works with problem and responder activity lists. Problems may be marked resolved or dismissed. Responder activities may be skipped only. Remediate  and execute options are not available, due to missing service level policies. 

```
allow group cg-ops to use cloud-guard-problems in $LOCATION
allow group cg-ops to use cloud-guard-responder-executions in $LOCATION

allow group cg-ops to inspect cloud-guard-family in $LOCATION
allow group cg-ops to inspect cloud-guard-config in tenancy
allow group cg-ops to read threat-intel-family in tenancy
```

>Notice 'inspect' privilege for cloud-guard-family, which makes OCI Console to show all other CloudGuard elements, w/o ability to look inside or modify. This privilege is required to see e.g. list of recommendations. Inspect on cloud-guard-config on tenancy level is required to run the Cloud Guard service.

#### Remediate
Cloud Guard service facilitates problem resolution delivering catalogue of responder activities. Activities are not automatic and requires operator approval, but once approved are executed by cloudguard service itself. Service documentation alerts about it.

>Caution! Enabling responders gives Cloud Guard permissions to modify security settings in your environment to remediate, on your behalf, problems that the responders detect. Ensure that granting these permissions does not violate your organization's security policies. 

Cloud Guard supported remedy will not work properly in situation your system is externally managed by e.g. terraform. Having such setup you should use terraform to make required changes. On the other hand it may be appropriate to make corrective action with Cloud Guard, and after this update terraform configuration files, under drift detection procedure.

```
allow service cloudguard to manage instance-family in $LOCATION
allow service cloudguard to manage object-family in $LOCATION
allow service cloudguard to manage buckets in $LOCATION
allow service cloudguard to manage users in $LOCATION
allow service cloudguard to manage policies in $LOCATION
allow service cloudguard to manage keys in $LOCATION
allow service cloudguard to manage private-ips in $LOCATION
allow service cloudguard to manage public-ips in $LOCATION
allow service cloudguard to manage internet-gateways in $LOCATION
allow service cloudguard to manage vcns in $LOCATION
allow service cloudguard to manage route-tables in $LOCATION
```

#### Block DELETE operation
Delete operation in the Cloud environment is very unsafe, as it's more than easy to destroy resources. CIS recommends to block delete in file storage resources, but it's good do extend this rule to other resources. 

Access statements should be written always with blocked delete operation.

```
allow group cg-admins to manage cloud-guard-targets in $LOCATION where request.permission!=/*_DELETE/
allow group cg-admins to manage cloud-guard-managed-lists in $LOCATION where request.permission!=/*_DELETE/
allow group cg-admins to manage cloud-guard-detector-recipes in $LOCATION where request.permission!=/*_DELETE/
allow group cg-admins to manage cloud-guard-responder-recipes in $LOCATION where request.permission!=/*_DELETE/
```

Multiple statements may be written in one to save iam service limits.

```
allow group cg-admins to manage cloud-guard-family in $LOCATION
where any {
    request.permission=/*_INSPECT/,
    all {
        request.permission!=/*_DELETE/,
        any {
            request.permission=/CG_TARGET_*/,
            request.permission=/CG_DETECTOR_RECIPE_*/,
            request.permission=/CG_RESPONDER_RECIPE_*/,
            request.permission=/CG_MANAGED_LIST_*/
        }
    }
}
```

## PT110|Externalize Cloud Guard OCI Responders 
Caution! Enabling responders gives Cloud Guard permissions to modify security settings in your environment to remediate, on your behalf, problems that the responders detect. Ensure that granting these permissions does not violate your organization's security policies.

### Progress
[x] Excel updated with Cloud Guard Responders (ciam_model_v7.xlsx)
[ ] Add user statements
[ ] Remove user statements from core Cloud Guard
[ ] Add service statements

### Documentation
https://docs.oracle.com/en-us/iaas/cloud-guard/using/respond-recipes-about.htm

## PT130|Support for tenancy level user group access statements 


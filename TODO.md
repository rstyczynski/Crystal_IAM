
# Policy templates
PT40|Remove 'AddIdpGroupMapping' and 'DeleteIdpGroupMapping' request.operation from identity-providers administrator rights (after CIS LZ)
PT60|Add vulnerability-scanning-service to policy profile
PT70|Add OSMS to policy profile
PT100|Fine tune Cloud Guard template
PT110|

## low priority
PT90|Add vault access to streaming, Fssoc4Prod 

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

Allow service blockstorage, oke, streaming, Fssoc4Prod to use keys in compartment security-cmp

## PT100|Fine tune Cloud Guard template

### Documentation
https://docs.public.oneportal.content.oci.oraclecloud.com/en-us/iaas/cloud-guard/using/prerequisites.htm#prerequisites


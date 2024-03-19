
# Policy templates
PT10|Policy statements required by services are available in templates
PT20|

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

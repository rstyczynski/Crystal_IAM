
# Policy templates
PT10|Policy statements required by services are available in templates

# Modeling
M10|Policy statements required by services are handled by the spreadsheet

# Logic
L10|Move bash code to proper style with command line arguments, error handling, etc.

# Done
M20|Access policies are attached to compartments, if needed
L20|Generated policies are written to timestamp directory under specified destination directory

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

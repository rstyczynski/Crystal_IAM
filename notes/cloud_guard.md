PT90|Fine tune Cloud Guard template
===================================

Cloud Guard is a cloud native service that helps customers monitor, identify, achieve, and maintain a strong security posture on Oracle Cloud. Use the service to examine your Oracle Cloud Infrastructure resources for security weakness related to configuration, and your Oracle Cloud Infrastructure operators and users for risky activities. Upon detection, Cloud Guard can suggest, assist, or take corrective actions, based on your configuration.[1]

OCI Cloud Guard is operated under following use cases:
1. Manager to enable Cloud Guard
2. Administrator to configure targets, detectors, managed-lists, and responders
3. Operator to work with problems i.e. mark as resolved or dismissed
4. Operator to work with problems to remediate, and responder activities to execute, or skip build-in actions.

Each of the use case requires different set of access statements for users, and cloudguard service itself. CloudGuard may operate on tenancy or compartment level, what means that it's possible to configure user with access privileges to control specific compartment only. 

Note that Cloud Guard is integrated with OCI services: Certificates, Data Safe, and Threat Intelligence [2]. This document does not describe this scope, and further extension will be done under PT91-93 requirements.

# Manage
Manage privilege is always a super power level to do all with the service. This level should be used only by a break glass user during initial tenancy configuration to enable CloudGuard. Manage is used to configure data masking, as exact resource name for this feature is unknown [3].

```
allow group breakglass to manage cloud-guard-family in tenancy
```

# Administrator
Administrator privilege gives ability to configure CloudGuard: setup targets, setup managed list;  clone, enable, and configure detectors; clone, enable, and configure responders.

```
allow group cg-admins to manage cloud-guard-targets in $LOCATION
allow group cg-admins to manage cloud-guard-managed-lists in $LOCATION
allow group cg-admins to manage cloud-guard-detector-recipes in $LOCATION
allow group cg-admins to manage cloud-guard-responder-recipes in $LOCATION

allow group cg-admins to inspect cloud-guard-family in $LOCATION
allow group cg-admins to inspect cloud-guard-config in tenancy
```

>Notice 'inspect' privilege for cloud-guard-family, which makes OCI Console to show all other Cloud Guard elements, w/o ability to look inside or modify them. This privilege is required to see e.g. list of recommendations. Inspect on cloud-guard-config on tenancy level is required to run the Cloud Guard service.

# Operator
Operator works with problem and responder activity lists. Problems may be marked resolved or dismissed. Responder activities may be skipped only. Remediate  and execute options are not available, due to missing service level policies. 

```
allow group cg-ops to use cloud-guard-problems in $LOCATION
allow group cg-ops to use cloud-guard-responder-executions in $LOCATION

allow group cg-ops to inspect cloud-guard-family in $LOCATION
allow group cg-ops to inspect cloud-guard-config in tenancy
```

# Remediate
Cloud Guard service facilitates problem resolution delivering catalogue of responder activities. Activities are not automatic and requires operator approval. Once approved, the remedy actions are executed by cloudguard service itself. Service documentation alerts about it, pointing out that such operation may be in conflict with cloud operational procedures of your organization.

>Caution! Enabling responders gives Cloud Guard permissions to modify security settings in your environment to remediate, on your behalf, problems that the responders detect. Ensure that granting these permissions does not violate your organization's security policies [4]. 

Note that Cloud Guard supported remedy will not work properly in situation your system is externally managed by e.g. terraform. Having such setup you should use terraform to make required changes. On the other hand it may be appropriate to make corrective action with Cloud Guard, and after this update terraform configuration files, under drift detection procedure.

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

# Block DELETE operation
Delete operation in the Cloud environment is very unsafe, as it's more than easy to destroy resources. CIS recommends to block delete in file storage resources, but it's good do extend this rule to other resources. 

Access statements should be written always with blocked delete operation.

```
allow group cg-admins to manage cloud-guard-targets in $LOCATION where request.permission!=/*_DELETE/
allow group cg-admins to manage cloud-guard-managed-lists in $LOCATION where request.permission!=/*_DELETE/
allow group cg-admins to manage cloud-guard-detector-recipes in $LOCATION where request.permission!=/*_DELETE/
allow group cg-admins to manage cloud-guard-responder-recipes in $LOCATION where request.permission!=/*_DELETE/
```

# Statement count optimization
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

# References
1. Cloud Guard home, https://docs.oracle.com/en-us/iaas/cloud-guard/home.htm
2. Integrating Cloud Guard with Other Services, https://docs.oracle.com/en-us/iaas/cloud-guard/using/part-start.htm#cg-integrate
3. Cloud Guard Policies, https://docs.oracle.com/en-us/iaas/cloud-guard/using/policies.htm
4. About OCI Responder Recipes, https://docs.oracle.com/en-us/iaas/cloud-guard/using/respond-recipes-about.htm

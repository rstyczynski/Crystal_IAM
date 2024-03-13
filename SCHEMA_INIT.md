# initialise policy scheme - test1

./bin/init_policies.sh audit audit-events audit_event https://docs.oracle.com/en-us/iaas/Content/Identity/Reference/auditpolicyreference.htm test1 .template 

./bin/init_policies.sh autonomous_database autonomous-database-family autonomous_database https://docs.public.oneportal.content.oci.oraclecloud.com/en-us/iaas/Content/Identity/policyreference/adbpolicyreference.htm#Policy_Details_for_Autonomous_Database test1 .template 

./bin/init_policies.sh bastion bastion-family bastion  https://docs.oracle.com/en-us/iaas/Content/Bastion/Reference/bastionpolicyreference.htm test1 .template 

./bin/init_policies.sh bastion_session bastion-family bastion_session  https://docs.oracle.com/en-us/iaas/Content/Bastion/Reference/bastionpolicyreference.htm test1 .template 

./bin/init_policies.sh budgets usage-budgets usage_budget https://docs.oracle.com/en-us/iaas/Content/Billing/Concepts/budgetsoverview.htm test1 .template


./bin/init_policies.sh leaf_certificate leaf-certificate-family n/a https://docs.oracle.com/en-us/iaas/Content/Identity/Reference/certificatespolicyreference.htm test1 .template-family

./bin/init_policies.sh certificate_authority certificate-authority-family n/a https://docs.oracle.com/en-us/iaas/Content/Identity/Reference/certificatespolicyreference.htm test1 .template-family


./bin/init_policies.sh cloud_advisor optimizer-api-family n/a https://docs.oracle.com/en-us/iaas/Content/CloudAdvisor/Reference/cloudadvisorpolicyreference.htm test1 .template-family

./bin/init_policies.sh cloud_shell claud-shell n/a  https://docs.oracle.com/en-us/iaas/Content/Bastion/Reference/bastionpolicyreference.htm test1 .template-useonly 

./bin/init_policies.sh cloud_guard cloud-guard-family n/a https://docs.oracle.com/en-us/iaas/Content/Identity/Reference/certificatespolicyreference.htm test1 .template-family

./bin/init_policies.sh compartment compartments compartment https://docs.public.oneportal.content.oci.oraclecloud.com/en-us/iaas/Content/Identity/policyreference/iampolicyreference.htm#top test1 .template

./bin/init_policies.sh cost\&usage usage-reports usage_report https://docs.oracle.com/en-us/iaas/Content/Billing/Concepts/costanalysisoverview.htm test1 .template

./bin/init_policies.sh dashboards dashboards-family n/a https://docs.oracle.com/en-us/iaas/Content/Dashboards/Reference/dashboardspolicyreference.htm test1 .template-family

./bin/init_policies.sh database database-family n/a https://docs.oracle.com/en/cloud/paas/base-database/iam-policy-details/index.html#GUID-630C92AC-7F6F-4BA9-840C-4806A3CCB601 test1 .template-family MANUAL

./bin/init_policies.sh dns dns n/a https://docs.oracle.com/en-us/iaas/Content/Identity/Reference/dnspolicyreference.htm test1 .template-family

./bin/init_policies.sh e-mail email-family n/a https://docs.oracle.com/en-us/iaas/Content/Identity/Reference/emailpolicyreference.htm test1 .template-family

./bin/init_policies.sh e-mail_dkim dkim dkim https://docs.oracle.com/en-us/iaas/Content/Identity/Reference/emailpolicyreference.htm test1 .template

./bin/init_policies.sh events cloudevents-rules EVENTRULE https://docs.oracle.com/en-us/iaas/Content/Identity/Reference/cloudeventspolicyreference.htm test1 .template MANUAL

./bin/init_policies.sh exadata_infrastructures cloud-exadata-infrastructures CLOUD_EXADATA_INFRASTRUCTURE https://docs.oracle.com/en/engineered-systems/exadata-cloud-service/ecscm/ecs-policy-details.html#GUID-A967AE72-E18C-40ED-A928-D865618E9B9E test1 .template 
```

./bin/init_policies.sh public_connectivity virtual-network-family none https://docs.oracle.com/en/engineered-systems/exadata-cloud-service/ecscm/ecs-policy-details.html#GUID-A967AE72-E18C-40ED-A928-D865618E9B9E test1 .template-family_exclude none none "NAT_GATEWAY  INTERNET_GATEWAY  SERVICE_GATEWAY  PUBLIC_IP_POOL  PUBLIC_IP  BYOIP_RANGE  IPV6"

./bin/init_policies.sh local_network virtual-network-family none https://docs.oracle.com/en/engineered-systems/exadata-cloud-service/ecscm/ecs-policy-details.html#GUID-A967AE72-E18C-40ED-A928-D865618E9B9E test1 .template-family_exclude none none "VCN  SUBNET  DHCP  VNIC_ATTACHMENT  VNIC  PRIVATE_IP"

./bin/init_policies.sh local_network_security virtual-network-family none https://docs.oracle.com/en/engineered-systems/exadata-cloud-service/ecscm/ecs-policy-details.html#GUID-A967AE72-E18C-40ED-A928-D865618E9B9E test1 .template-family_exclude none none "NETWORK-SECURITY-GROUP  SECURITY-LIST"


./bin/init_policies.sh external_connectivity virtual-network-family none https://docs.oracle.com/en/engineered-systems/exadata-cloud-service/ecscm/ecs-policy-details.html#GUID-A967AE72-E18C-40ED-A928-D865618E9B9E test1 .template-family_exclude none none "REMOTE_PEERING_CONNECTION REMOTE_PEERING_CONNECTION_CONNECT_TO REMOTE_PEERING_CONNECTION_CONNECT_FROM"

./bin/init_policies.sh file_system file-family none https://docs.oracle.com/en-us/iaas/Content/Identity/Reference/filestoragepolicyreference.htm test1 .template-family

./bin/init_policies.sh iam_access_policy all-resources none https://docs.public.oneportal.content.oci.oraclecloud.com/en-us/iaas/Content/Identity/policyreference/iampolicyreference.htm#top test1 .template-family_exclude none none "GROUP  DYNAMIC_GROUP  NETWORK_SOURCE  POLICY  CREDENTIAL"

./bin/init_policies.sh iam_identity all-resources none https://docs.public.oneportal.content.oci.oraclecloud.com/en-us/iaas/Content/Identity/policyreference/iampolicyreference.htm#top test1 .template-family_exclude none none "DOMAIN  IDENTITY_PROVIDER  AUTHENTICATION_POLICY USER  GROUP"


./bin/init_policies.sh iam_data_hall all-resources none https://docs.public.oneportal.content.oci.oraclecloud.com/en-us/iaas/Content/Identity/policyreference/iampolicyreference.htm#top test1 .template-family_exclude none none "TENANCY  COMPARTMENT"

./bin/init_policies.sh iam_tag all-resources none https://docs.public.oneportal.content.oci.oraclecloud.com/en-us/iaas/Content/Identity/policyreference/iampolicyreference.htm#top test1 .template-family_exclude none none "TAG_DEFAULT TAG_NAMESPACE"

./bin/init_policies.sh iam_tag_namespaces tag_namespaces TAG_NAMESPACE https://docs.public.oneportal.content.oci.oraclecloud.com/en-us/iaas/Content/Identity/policyreference/iampolicyreference.htm#top test1 .template

./bin/init_policies.sh iam_tag_defaults tag_defaults TAG_DEFAULT https://docs.public.oneportal.content.oci.oraclecloud.com/en-us/iaas/Content/Identity/policyreference/iampolicyreference.htm#top test1 .template


./bin/init_policies.sh instance instance-family none https://docs.oracle.com/en-us/iaas/Content/Identity/Reference/corepolicyreference.htm test1 .template-family

./bin/init_policies.sh inter_connectivity virtual-network-family none https://docs.oracle.com/en/engineered-systems/exadata-cloud-service/ecscm/ecs-policy-details.html#GUID-A967AE72-E18C-40ED-A928-D865618E9B9E test1 .template-family_exclude none none "VIRTUAL_CIRCUIT  CROSS_CONNECT  CROSS_CONNECT_GROUP  IPSEC_CONNECTION  IPSEC_CONNECTION_DEVICE_CONFIG  CPE"

./bin/init_policies.sh kubernetes cluster-family none https://docs.oracle.com/en-us/iaas/Content/Identity/Reference/contengpolicyreference.htm#Details_for_Container_Engine_for_Kubernetes test1 .template-family

./bin/init_policies.sh load_balancer load_balancers LOAD_BALANCER https://docs.oracle.com/en-us/iaas/Content/Identity/Reference/corepolicyreference.htm test1 .template

./bin/init_policies.sh local_connectivity virtual-network-family none https://docs.oracle.com/en/engineered-systems/exadata-cloud-service/ecscm/ecs-policy-details.html#GUID-A967AE72-E18C-40ED-A928-D865618E9B9E test1 .template-family_exclude none none "LOCAL_PEERING_GATEWAY  LOCAL_PEERING_GATEWAY_CONNECT_FROM  LOCAL_PEERING_GATEWAY_CONNECT_TO"

./bin/init_policies.sh log_group log-group none https://docs.oracle.com/en-us/iaas/Content/Logging/Task/managinglogs.htm test1 .template-family

./bin/init_policies.sh log_content log-content none https://docs.oracle.com/en-us/iaas/Content/Logging/Task/managinglogs.htm test1 .template-family

./bin/init_policies.sh log_unified_configuration unified-configuration none https://docs.oracle.com/en-us/iaas/Content/Logging/Task/managinglogs.htm test1 .template-family

./bin/init_policies.sh monitoring all-resources none https://docs.public.oneportal.content.oci.oraclecloud.com/en-us/iaas/Content/Identity/policyreference/monitoringpolicyreference.htm test1 .template-family_exclude none none "ALARM METRIC"

./bin/init_policies.sh notification ons-family none https://docs.oracle.com/en-us/iaas/Content/Logging/Task/managinglogs.htm test1 .template-family

./bin/init_policies.sh object_storage object-family none https://docs.oracle.com/en-us/iaas/Content/Identity/policyreference/objectstoragepolicyreference.htm test1 .template-family

./bin/init_policies.sh quota quota QUOTA https://docs.oracle.com/en-us/iaas/Content/Quotas/Concepts/resourcequotas_authentication_and_authorization.htm test1 .template

./bin/init_policies.sh routing virtual-network-family none https://docs.oracle.com/en/engineered-systems/exadata-cloud-service/ecscm/ecs-policy-details.html#GUID-A967AE72-E18C-40ED-A928-D865618E9B9E test1 .template-family_exclude none none "DRG  ROUTE_TABLE"

./bin/init_policies.sh security_zone security-zone SECURITY_ZONE https://docs.oracle.com/en-us/iaas/security-zone/using/security-zone-iam-policies.htm test1 .template MANUAL

./bin/init_policies.sh vault_keys key-family none https://docs.oracle.com/en-us/iaas/Content/Identity/Reference/keypolicyreference.htm#Details_for_the_Vault_Service test1 .template-family

./bin/init_policies.sh vault_secrets secret-family none https://docs.oracle.com/en-us/iaas/Content/Identity/Reference/keypolicyreference.htm#Details_for_the_Vault_Service test1 .template-family

./bin/init_policies.sh inter_connectivity_security firewall-family none https://docs.oracle.com/en-us/iaas/Content/network-firewall/iam-policy-reference.htm test1 .template-family

./bin/init_policies.sh external_connectivity_security firewall-family none https://docs.oracle.com/en-us/iaas/Content/network-firewall/iam-policy-reference.htm test1 .template-family

./bin/init_policies.sh public_connectivity_security firewall-family none https://docs.oracle.com/en-us/iaas/Content/network-firewall/iam-policy-reference.htm test1 .template-family

./bin/init_policies.sh apm apm-domains apm_domain https://docs.oracle.com/en-us/iaas/Content/Identity/Reference/apmpolicyreference.htm test1 .template 

./bin/init_policies.sh log_analytics loganalytics-resources-family none https://docs.public.oneportal.content.oci.oraclecloud.com/en-us/iaas/logging-analytics/doc/iam-policies-catalog-logging-analytics.html v0.1 .template-family


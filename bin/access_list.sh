#!/bin/bash

access_list=$1
policy_profile_name=$2
tx_id=$3

# set tx identifier default value if not provided
: ${policy_profile_name:="v0.2"}
: ${tx_id:="created by $(whoami) on $(date) with policy profile: $policy_profile_name"}
: ${compartment_pfx:='cmp-'}

: ${csv_delim:=','}
: ${csv_quotation:='"'}
: ${param_delim:="|"}

: ${policy_out:=./out}
: ${tmp:=./tmp}

privilege_clusters="COR C I R O U D M"

policy_profile=./profiles/$policy_profile_name

location_row=13
resource_row=14
access_groups_column=1


mkdir -p $tmp
mkdir -p $policy_out

# decode_privilege_code() {
#     case $1 in
#         C) echo "create" ;;
#         U) echo "use" ;;
#         T) echo "tune" ;;
#         D) echo "decommission" ;;
#         I) echo "inspect" ;;
#         M) echo "manage" ;;
#         *) echo "unknown" ;;
#     esac
# }
decode_privilege_code() {
    case $1 in
        COR) echo "admin" ;;
        C) echo "create" ;;
        U) echo "use" ;;
        O) echo "optimise" ;;
        R) echo "retire" ;;
        D) echo "decommission" ;;
        I) echo "inspect" ;;
        M) echo "manage" ;;
        P) echo "plan" ;;
        *) echo "unknown" ;;
    esac
}

cat $access_list | head -$location_row | tail -1 | tr "$csv_delim" '\n' > $tmp/location.tmp
cat $access_list | head -$resource_row | tail -1 | tr "$csv_delim" '\n' > $tmp/resource.tmp

access_groups=$(cat $access_list | grep "^$csv_quotation-" | cut -d "$csv_delim" -f$access_groups_column | sed 's/- //g' | tr -d "$csv_quotation")

echo "=========== ACCESS GROUPS =========="
echo $access_groups
echo "===================================="

# test on one group
# access_groups=audit
# access_groups=compliance_admin
# access_groups=access_admin
access_groups=compute_operator_appgrp1
for access_group in $access_groups; do
    echo "=========== ACCESS GROUP ==========="
    echo $access_group
    echo "===================================="

    rm -f $tmp/$access_group.tmp

    # M20|Access policies are attached to compartments, if needed
    unset attached_at

    echo "cat $access_list | grep \"^$csv_quotation- $access_group$csv_quotation$csv_delim\""  
    cat $access_list | grep "^$csv_quotation\s*- $access_group$csv_quotation$csv_delim" | tr "$csv_delim" '\n'  > $tmp/priviliges.tmp
    
    paste -d, $tmp/location.tmp $tmp/resource.tmp $tmp/priviliges.tmp | grep -v 'Team,team,' > $tmp/line.tmp

    while IFS=',' read -r location resource privileges; do
 
         # skip empty lines i.e. when access_group is empty
        if [ -z "$location" ]; then
            echo "Info. Location empty. Skiping this line."
            continue
        fi

        echo " ==== BEFORE CLEANUP"
        echo "Access group:>$access_group<"
        echo "Location:>$location<"
        echo "Resource:>$resource<"
        echo "Priviliges:>$privileges<"

        # remove csv_quotation
        access_group="${access_group//$csv_quotation}"
        location="${location//$csv_quotation}"
        resource="${resource//$csv_quotation}"
        privileges="${privileges//$csv_quotation}"

        # trim leading whitespaces 
        access_group="${access_group#"${access_group%%[![:space:]]*}"}"
        location="${location#"${location%%[![:space:]]*}"}"
        resource="${resource#"${resource%%[![:space:]]*}"}"
        privileges="${privileges#"${privileges%%[![:space:]]*}"}"

        # M20|Access policies are attached to compartments, if needed
        if [ "$location" == "attach at" ]; then
            if [ -z "$privileges" ]; then
                attached_at=tenancy
            else
                attached_at=$privileges
            fi
            echo "Info. Policy attached at $attached_at"
            continue
        fi

        # get parameters

        # let location be like entered by operator
        location=$(echo $location | tr [A-Z] [a-z])
        unset location_parameters
        if [[ $location == */* ]]; then
            location_parameters=$(echo $location | cut -f2 -d'/')
            location_parameters="${location_parameters#"${location_parameters%%[![:space:]]*}"}"

            location=$(echo $location | cut -f1 -d'/' | tr -d ' ')
            echo "Location: $location comes with $location_parameters"
        fi
        location=$(echo $location | tr ' ' '_')
        location_p1=$(echo $location_parameters | awk -F$param_delim -v col="1" '{print $col}')
        location_p2=$(echo $location_parameters | awk -F$param_delim -v col="2" '{print $col}')
        location_p3=$(echo $location_parameters | awk -F$param_delim -v col="3" '{print $col}')
        location_p4=$(echo $location_parameters | awk -F$param_delim -v col="4" '{print $col}')

        # let resource be like entered by operator
        #resource=$(echo $resource | tr [A-Z] [a-z])
        unset resource_parameters
        if [[ $resource == */* ]]; then
            resource_parameters=$(echo $resource | cut -f2 -d'/')
            resource_parameters="${resource_parameters#"${resource_parameters%%[![:space:]]*}"}"

            resource=$(echo $resource | cut -f1 -d'/' | tr -d ' ')
            echo "Resource: $resource comes with $resource_parameters"
        fi
        resource=$(echo $resource | tr ' ' '_')
        resource_p1=$(echo $resource_parameters | awk -F$param_delim -v col="1" '{print $col}')
        resource_p2=$(echo $resource_parameters | awk -F$param_delim -v col="2" '{print $col}')
        resource_p3=$(echo $resource_parameters | awk -F$param_delim -v col="3" '{print $col}')
        resource_p4=$(echo $resource_parameters | awk -F$param_delim -v col="4" '{print $col}')

        # skip empty lines i.e. when access_group is empty
        if [ -z "$access_group" ]; then
            echo "Info. Access group empty. Skiping this line."
            continue
        fi

        echo " ==== AFTER CLEANUP"
        echo "Access group:>$access_group<"
        echo "Location:>$location<"
        echo "Location parameters:>$location_parameters<"
        echo "Resource location no.1:>$location_p1<"
        echo "Resource location no.2:>$location_p2<"
        echo "Resource location no.3:>$location_p3<"
        echo "Resource location no.4:>$location_p4<"

        echo "Resource:>$resource<"
        echo "Resource parameters:>$resource_parameters<"
        echo "Resource parameter no.1:>$resource_p1<"
        echo "Resource parameter no.2:>$resource_p2<"
        echo "Resource parameter no.3:>$resource_p3<"
        echo "Resource parameter no.4:>$resource_p4<"
        echo "Priviliges:>$privileges<"

        if [ ! -d "$policy_profile/$resource" ]; then
            echo "Error: access definition not found for $resource."
            exit 1
        fi

        # compartment or tenancy level policy?
        if [ "$location" == "tenancy" ]; then
            location="tenancy"
        elif [ "$location" == "$attached_at" ]; then
            location="compartment $compartment_pfx$location"
        else
            # add prefix before each compartment level
            unset location_full
            IFS=:
            for compartment in $location; do
                if [ -z "$location_full" ]; then
                    location_full=$compartment_pfx$compartment
                else
                    location_full=$location_full:$compartment_pfx$compartment
                fi
            done
            unset IFS

            location="compartment $location_full"
        fi

        if [ -z "$privileges" ]; then
            echo "Warning: No priviliges defined for $resource"
            continue
        fi

        # M20|Access policies are attached to compartments, if needed
        if [ ! "$attached_at" = tenancy ]; then
            if expr "$location" : "compartment $compartment_pfx$attached_at.*"; then
                # remove attached_at compartment from compartment path
                location="compartment ${location#compartment $compartment_pfx$attached_at:}"
            else
                echo "Error. Access specified to resource not accesible from attachment point at: compartment $compartment_pfx$attached_at vs. $location".
                exit 1
            fi
        fi

        # decode privileges
        unset privileges_set
        for privilege_cluster in $privilege_clusters; do
            echo "Pre processing $privilege_cluster.."
            echo "$privileges_set" | grep $privilege_cluster
            if [ $? -ne 0 ]; then
                index=0
                while [ $index -lt ${#privileges} ]; do
                    privilege_code="${privileges:$index:${#privilege_cluster}}"
                    
                    if [ "$privilege_code" = "$privilege_cluster" ]; then
                        if [ ! -z "$privileges_set" ]; then
                            privileges_set="$privileges_set;$privilege_cluster"
                        else
                            privileges_set="$privilege_cluster"
                        fi
                    fi 

                    index=$(($index + ${#privilege_cluster}))
                    echo "$index, >>$privileges_set<<, $privilege_code"
                done
            fi
        done

        # index=0
        # while [ $index -lt ${#privileges} ]; do
        #     privilege_code="${privileges:$index:1}"
        #     ((index++))
        echo "privileges_set: $privileges_set"
        for privilege_code in $(echo $privileges_set | tr ';' '\n'); do  
            echo "Processing $privilege_code..."
            if [ $privilege_code = "P" ]; then
                continue
            fi

            privilege_name=$(decode_privilege_code $privilege_code)
            if [ "$privilege_name" == "unknown" ]; then
                echo "- privilege at position $index: $privilege_code -> unknown!"
                echo "Access group: $access_group"
                echo "Priviliges: $privileges"
                exit 2
            else
                echo "- privilege at position $index: $privilege_code -> $privilege_name"
                if [ ! -f "$policy_profile/$resource/$privilege_name" ]; then
                    if [ -f "$policy_profile/$resource/$privilege_name.not_supported" ]; then
                        echo "Info: $privilege_name not supported for $resource."
                    else
                        echo "Error: privilege definition not found for $resource/$privilege_name."
                        exit 1
                    fi
                fi

                echo "Saving to: $tmp/$access_group.tmp"
                
                # look for alerts
                cat "$policy_profile/$resource/$privilege_name" |
                grep "^\s*!" >/dev/null
                if [ $? -eq 0 ]; then
                    privilege_alert=$( cat "$policy_profile/$resource/$privilege_name" | grep "^\s*!" | cut -f2 -d'!')
                    echo "Info: $resource/$privilege_name - $privilege_alert"
                else
                    # update variables in templates and adjust formatting
                    # Note that list of words starting new line muyst be handled. 
                    # Now it's: (1) allow.
                    cat "$policy_profile/$resource/$privilege_name" |
                    grep -v "^\s*#" | # remove comments 
                    sed "s/\$GROUP/$access_group/g" | # update group name
                    sed "s/\$LOCATION/$location/g" | # update location
                    sed "s/\$LOCATION_P1/$location_p1/g" | # update location
                    sed "s/\$LOCATION_P2/$location_p2/g" | # update location  
                    sed "s/\$LOCATION_P3/$location_p3/g" | # update location  
                    sed "s/\$LOCATION_P4/$location_p4/g" | # update location                    sed "s/\$LOCATION/$location/g" | # update location
                    sed "s/\$RESOURCE_P1/$resource_p1/g" | # update location
                    sed "s/\$RESOURCE_P2/$resource_p2/g" | # update location
                    sed "s/\$RESOURCE_P3/$resource_p3/g" | # update location
                    sed "s/\$RESOURCE_P4/$resource_p4/g" | # update location
                    sed "s|\$COMMENT|NOTE:$resource/$privilege_name tx:$tx_id|g" | # update comment
                    tr '[\n\t]' ' ' | # convert to one line, remove tabs
                    tr -s ' ' |    # remove duplicated spaces
                    sed 's/allow/\nallow/g' | # new line before allow /adjustment for multi statement templates/
                    sed 's/endorse/\nendorse/g' | # new line before endorse /adjustment for multi statement templates/
                    sed 's/admit/\nadmit/g' | # new line before admit /adjustment for multi statement templates/
                    sed 's/define/\ndefine/g' | # new line before define /adjustment for multi statement templates/
                    cat >> $tmp/$access_group.tmp
                    echo >> $tmp/$access_group.tmp

                    # verify that no empty placeholders are left in policy
                    cat $tmp/$access_group.tmp | grep "\\$" >/dev/null
                    if [ $? -eq 0 ]; then
                        cat $tmp/$access_group.tmp
                        echo "Error: policy template placeholder not substituted!"
                        exit 1
                    fi
                fi
            fi

            # M20|Access policies are attached to compartments, if needed
            mkdir -p $policy_out/$attached_at

            # process access policy file
            cat $tmp/$access_group.tmp |
            sed '/^$/d' | # remove empty lines
            sed 's/^[ ]*//' | # remove leading spaces
            sort -u | # remove duplicated policies
            cat > $policy_out/$attached_at/$access_group
        done
    done < "$tmp/line.tmp"
done

rm -f $tmp/*.tmp
echo "Completed."

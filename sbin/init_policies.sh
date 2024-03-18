#!/bin/bash

RESOURCE=$1
RESOURCE_AIM=$2
RESOURCE_CODE=$3
URL=$4
SCHEME=$5
TEMPLATE=$6
MANUAL=$7
EXCLUDE_RESOURCES=$8
EXCLUSIVE_RESOURCES=$9

pg_root=.

RESOURCE_CODE=$(echo $RESOURCE_CODE | tr [a-z] [A-Z])
mkdir -p $pg_root/scheme/$SCHEME/$RESOURCE

if [ -f $pg_root/scheme/$SCHEME/$RESOURCE/.manual ]; then
    echo "Error. This policy scheme was mofied manually. To continue remove existing files."
    exit 1
fi

if [ "$EXCLUDE_RESOURCES" != "none" ]; then
  unset SNIPPET_EXCLUDE_RESOURCES
  for resource_name in $EXCLUDE_RESOURCES; do
      if [ -z "$SNIPPET_EXCLUDE_RESOURCES" ]; then
          SNIPPET_EXCLUDE_RESOURCES="request.permission!=/${resource_name}_*/"
      else
          SNIPPET_EXCLUDE_RESOURCES="$SNIPPET_EXCLUDE_RESOURCES, request.permission!=/${resource_name}_*/"
      fi
  done
  echo "===="
  echo "Exclude: $SNIPPET_EXCLUDE_RESOURCES"
  echo "===="
fi

if [ "$EXCLUSIVE_RESOURCES" != "none" ]; then
  unset SNIPPET_EXCLUSIVE_RESOURCES
  for resource_name in $EXCLUSIVE_RESOURCES; do
      if [ -z "$SNIPPET_EXCLUSIVE_RESOURCES" ]; then
          SNIPPET_EXCLUSIVE_RESOURCES="request.permission=/${resource_name}_*/"
      else
          SNIPPET_EXCLUSIVE_RESOURCES="$SNIPPET_EXCLUSIVE_RESOURCES, request.permission=/${resource_name}_*/"
      fi
  done
  echo "===="
  echo "Exclusive: $SNIPPET_EXCLUSIVE_RESOURCES"
  echo "===="
  
  if [ ! -z "$SNIPPET_EXCLUDE_RESOURCES" ]; then
    SNIPPET_RESOURCES="$SNIPPET_EXCLUDE_RESOURCES, any {$SNIPPET_EXCLUSIVE_RESOURCES}"
  else
    SNIPPET_RESOURCES="any {$SNIPPET_EXCLUSIVE_RESOURCES}"
  fi
else
  SNIPPET_RESOURCES=$SNIPPET_EXCLUDE_RESOURCES
fi

  echo "===="
  echo "Exclude & Exclusive: $SNIPPET_RESOURCES"
  echo "===="


for operation in create inspect read use tune decommission manage; do 
  echo "$RESOURCE/$operation"
  if [ -f $pg_root/scheme/$SCHEME/$RESOURCE/$operation ]; then
    echo "- permission template exists."
  else
    if [ -f $pg_root/scheme/$SCHEME/$RESOURCE/$operation ]; then
        mv $pg_root/scheme/$SCHEME/$RESOURCE/$operation $pg_root/scheme/$SCHEME/$RESOURCE/$operation.bak
    fi
    cat $pg_root/scheme/$SCHEME/$TEMPLATE/$operation |
    sed "s|\$RESOURCE_AIM|$RESOURCE_AIM|g" |
    sed "s|\$RESOURCE_CODE|$RESOURCE_CODE|g" |
    sed "s|\$SNIPPET_RESOURCES|$SNIPPET_RESOURCES|g" |
    sed "s|\$URL|$URL|g" |
    cat > $pg_root/scheme/$SCHEME/$RESOURCE/$operation
    echo "$TEMPLATE" > $pg_root/scheme/$SCHEME/$RESOURCE/.template
    echo "- created."
  fi
done

if [ "$MANUAL" == MANUAL ]; then
    touch $pg_root/scheme/$SCHEME/$RESOURCE/.manual
fi

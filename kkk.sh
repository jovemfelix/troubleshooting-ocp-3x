#!/bin/bash

THIS_SCRIPT=$(basename -- "$0")
echo Executando $THIS_SCRIPT
#set -e
# check nodes unscheduled
NODES_UNSCHEDULABLE_SIZE=$(oc get nodes --field-selector spec.unschedulable=true | awk 'FNR > 1  {print}' | wc -l | xargs)

if [[ ${NODES_UNSCHEDULABLE_SIZE} != '0' ]]; then
  TITLE="[NODES_UNSCHEDULABLE_SIZE] : ${NODES_UNSCHEDULABLE_SIZE}"
  HEADER="=======\n${TITLE}\n-------;----------"
  BODY=$(oc get nodes --field-selector spec.unschedulable=true)
  echo "${HEADER%;*}\n${BODY#*;}\n"
fi


## Explorar status dos nodes
#tail nodes <> not Ready
#tail pods <> not Running | Completed
#tail event

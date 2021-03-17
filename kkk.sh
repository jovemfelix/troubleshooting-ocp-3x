#!/bin/bash

THIS_SCRIPT=$(basename -- "$0")
echo Executando $THIS_SCRIPT

# check nodes unscheduled
NODES_UNSCHEDULABLE_SIZE=$(oc get nodes --field-selector spec.unschedulable=true | awk 'FNR > 1  {print}' | wc -l | xargs)

if [[ ${NODES_UNSCHEDULABLE_SIZE} != '0' ]]; then
  TITLE="[NODES_UNSCHEDULABLE_SIZE] : ${NODES_UNSCHEDULABLE_SIZE}"
  HEADER="=======\n${TITLE}\n-------;----------"
  BODY=$(oc get nodes --field-selector spec.unschedulable=true)
  echo "${HEADER%;*}\n${BODY#*;}\n"
fi

# check nodes NOT (unscheduled and ready)
NODES_NOT_SCHEDULED_OR_READY_SIZE=$(oc get nodes | awk 'FNR > 1 {if ($2!="Ready" && $2 !~ /SchedulingDisabled/)  print}' | wc -l | xargs)

if [[ ${NODES_NOT_SCHEDULED_OR_READY_SIZE} != '0' ]]; then
  TITLE="[NODES_NOT_SCHEDULED_OR_READY_SIZE] : ${NODES_NOT_SCHEDULED_OR_READY_SIZE}"
  HEADER="=======\n${TITLE}\n-------;----------"
  BODY=$(oc get nodes | awk 'FNR > 1 {if ($2!="Ready" && $2 !~ /SchedulingDisabled/)  print}')
  echo "${HEADER%;*}\n${BODY#*;}\n"
fi

## Explorar status dos nodes
#tail nodes <> not Ready
#tail pods <> not Running | Completed
#tail event

#!/bin/bash

THIS_SCRIPT=$(basename -- "$0")

# check nodes unscheduled
NODES_UNSCHEDULABLE_SIZE=$(oc get nodes --field-selector spec.unschedulable=true | awk 'FNR > 1  {print}' | wc -l | xargs)

if [[ ${NODES_UNSCHEDULABLE_SIZE} != '0' ]]; then
  TITLE="[NODES_UNSCHEDULABLE_SIZE] : ${NODES_UNSCHEDULABLE_SIZE}"
  HEADER="=======\n${TITLE}\n-------;----------"
  BODY=$(oc get nodes --field-selector spec.unschedulable=true)
  echo "${HEADER%;*}\n${BODY#*;}\n"
fi

# check nodes NOT (unscheduled and ready)
NODES_NOT_SCHEDULED_OR_READY_SIZE=$(oc get nodes --ignore-not-found | awk 'FNR > 1 {if ($2!="Ready" && $2 !~ /SchedulingDisabled/)  print}' | wc -l | xargs)

if [[ ${NODES_NOT_SCHEDULED_OR_READY_SIZE} != '0' ]]; then
  TITLE="[NODES_NOT_SCHEDULED_OR_READY_SIZE] : ${NODES_NOT_SCHEDULED_OR_READY_SIZE}"
  HEADER="=======\n${TITLE}\n-------;----------"
  BODY=$(oc get nodes | awk 'FNR > 1 {if ($2!="Ready" && $2 !~ /SchedulingDisabled/)  print}')
  echo "${HEADER%;*}\n${BODY#*;}\n"
fi

TITLE="[NAMESPACE] : $(oc project -q)"
HEADER="=======\n${TITLE}\n-------;----------"
echo "${HEADER%;*}\n"

# check project events that are not (Normal)
EVENT_NOT_NORMAL_SIZE=$(oc get events --field-selector type!=Normal --ignore-not-found | wc -l | xargs)

if [[ ${EVENT_NOT_NORMAL_SIZE} != '0' ]]; then
  TITLE="[EVENT_NOT_NORMAL_SIZE] : ${EVENT_NOT_NORMAL_SIZE}"
  HEADER="=======\n${TITLE}\n-------;----------"
  BODY=$(oc get events --field-selector type!=Normal)
  echo "${HEADER%;*}\n${BODY#*;}\n"
fi

# check pods with the state that are not (Running)
POD_NOT_RUNNIG_SIZE=$(oc get pods --field-selector=status.phase!=Running --ignore-not-found | awk 'FNR > 1 {if ($3!="Completed") print}'| wc -l | xargs)

if [[ ${POD_NOT_RUNNIG_SIZE} != '0' ]]; then
  TITLE="[POD_NOT_RUNNIG_SIZE] : ${POD_NOT_RUNNIG_SIZE}"
  HEADER="=======\n${TITLE}\n-------;----------"
  BODY=$(oc get pods --field-selector=status.phase!=Running | awk 'FNR > 1 {if ($3!="Completed") print}')
  echo "${HEADER%;*}\n${BODY#*;}\n"
fi

for POD in $(oc get pods --field-selector=status.phase==!=Running --ignore-not-found | awk 'FNR > 1 {if ($3!="Completed") print $1}') ; do
  TITLE="[POD_NAME] : ${POD}"
  HEADER="=======\n${TITLE}\n-------;----------"
  BODY=$(oc logs pod ${POD})
  echo "${HEADER%;*}\n${BODY#*;}\n"
done
## loop all project Pods to get event
#oc describe pod cakephp-ex-1-build | awk '/Events/{y=1;next}y'

FOOTER="=======\n"
echo $FOOTER
## Explorar status dos nodes
#tail nodes <> not Ready
#tail event
#tail pods <> not Running | Completed

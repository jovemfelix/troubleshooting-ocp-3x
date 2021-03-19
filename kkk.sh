#!/bin/bash
set -e

# check nodes unscheduled
NODES_UNSCHEDULABLE_SIZE=$(oc get nodes --field-selector spec.unschedulable=true --ignore-not-found  | awk 'FNR > 1  {print}' | wc -l | xargs)

if [[ ${NODES_UNSCHEDULABLE_SIZE} != '0' ]]; then
  TITLE="[NODES_UNSCHEDULABLE_SIZE] : ${NODES_UNSCHEDULABLE_SIZE}"
  HEADER="=======\n${TITLE}\n-------;----------"
  BODY=$(oc get nodes --field-selector spec.unschedulable=true)
  printf "${HEADER%;*}\n${BODY#*;}\n"
fi

# check nodes NOT (unscheduled and ready)
NODES_NOT_SCHEDULED_OR_READY_SIZE=$(oc get nodes --ignore-not-found | awk 'FNR > 1 {if ($2!="Ready" && $2 !~ /SchedulingDisabled/)  print}' | wc -l | xargs)

if [[ ${NODES_NOT_SCHEDULED_OR_READY_SIZE} != '0' ]]; then
  TITLE="[NODES_NOT_SCHEDULED_OR_READY_SIZE] : ${NODES_NOT_SCHEDULED_OR_READY_SIZE}"
  HEADER="=======\n${TITLE}\n-------;----------"
  BODY=$(oc get nodes | awk 'FNR > 1 {if ($2!="Ready" && $2 !~ /SchedulingDisabled/)  print}')
  printf "${HEADER%;*}\n${BODY#*;}\n"
fi

TITLE="[NAMESPACE] : $(oc project -q)"
HEADER="=======\n${TITLE}\n-------;----------"
printf "${HEADER%;*}\n"

# check project events that are not (Normal)
EVENT_NOT_NORMAL_SIZE=$(oc get events --field-selector type!=Normal --ignore-not-found | wc -l | xargs)

if [[ ${EVENT_NOT_NORMAL_SIZE} != '0' ]]; then
  TITLE="[EVENT_NOT_NORMAL_SIZE] : ${EVENT_NOT_NORMAL_SIZE}"
  HEADER="=======\n${TITLE}\n-------;----------"
  BODY=$(oc get events --field-selector type!=Normal --sort-by='.metadata.creationTimestamp')
  printf "${HEADER%;*}\n${BODY#*;}\n"
fi

# check pods with the state that are not (Running)
POD_NOT_RUNNIG_SIZE=$(oc get pods --ignore-not-found | awk 'FNR > 1 {if ($3!="Completed" && $3!="Running") print}'| wc -l | xargs)

if [[ ${POD_NOT_RUNNIG_SIZE} != '0' ]]; then
  TITLE="[POD_NOT_RUNNIG_SIZE] : ${POD_NOT_RUNNIG_SIZE}"
  HEADER="=======\n${TITLE}\n-------;----------"
  BODY=$(oc get pods --ignore-not-found | awk 'FNR > 1 {if ($3!="Completed" && $3!="Running") print}')
  printf "${HEADER%;*}\n${BODY#*;}\n"
fi

for POD in $(oc get pods --ignore-not-found | awk 'FNR > 1 {if ($3!="Completed" && $3!="Running") print $1}') ; do
  TITLE="[POD_NAME] : ${POD}"
  HEADER="=======\n${TITLE}\n-------;----------"
  BODY=$(oc logs ${POD})
  printf "${HEADER%;*}\n${BODY#*;}\n"
done
## loop all project Pods to get event
#oc describe pod cakephp-ex-1-build | awk '/Events/{y=1;next}y'

FOOTER="=======\n"
printf $FOOTER
## Explorar status dos nodes
#tail nodes <> not Ready
#tail event
#tail pods <> not Running | Completed

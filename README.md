## Plataforma

Manage OpenShift Container Platform
Manage users and policies
Control access to resources
Configure networking components
Configure pod scheduling





## Prática

case001

kkk.sh

?



```shell
# remover node
oc adm manage-node node2.337c.internal --schedulable=false

# listar o node q não faz parte
oc get nodes --field-selector spec.unschedulable=true
```



# Stuffs

```shell
oc get nodes -o yaml > nodes.yaml
```





# Referências Internas

1. OCP 4x - Troubleshooting Application Pods with the OpenShift Web [Console](https://role.rhu.redhat.com/rol-rhu/app/seminar/exps174-1)

# Referências Públicas

1. Troubleshooting OpenShift Clusters and [Workloads](https://towardsdatascience.com/troubleshooting-openshift-clusters-and-workloads-382664018935)
2. [23](https://medium.com/faun/kubectl-commands-cheatsheet-43ce8f13adfb) Advanced kubectl commands


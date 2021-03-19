# CASE 002

## OBJETIVO



## Plataforma

Manage OpenShift Container Platform
Manage users and policies
Control access to resources
Configure networking components
Configure pod scheduling





## TODO

1. Falar de DEBUG
   1. https://www.openshift.com/blog/debugging-java-applications-on-openshift-kubernetes?extIdCarryOver=true&sc_cid=701f2000001Css5AAC
   2. https://developers.redhat.com/blog/2016/07/21/debugging-java-applications-using-the-red-hat-container-development-kit/
2. Explorar Health check [exemplo](https://access.redhat.com/solutions/2921101)



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



## labm001

nao foi para frente

```shell
oc new-project labm001
oc -n openshift get secret imagestreamsecret --export -o yaml | oc apply -f -

oc new-app --docker-image=quay.io/redhattraining/php-hello-dockerfile --name=php-hello
```



## labm002

https://role.rhu.redhat.com/rol-rhu/app/courses/do288-4.5/pages/ch01s10

```
node js com package.json inválido
```



## labm003

### setup

```shell
GITHUB_USER=jovemfelix
LAB_NAME=elvis
oc new-app --name elvis https://github.com/${GITHUB_USER}/DO288-apps --context-dir hello-java
```

### diagnostic

```shell
oc get $(oc get pod -lapp=${LAB_NAME} -oname) -o yaml | oc adm policy scc-subject-review -f -
```

### solution

```shell
oc create serviceaccount ${LAB_NAME}-sa
oc adm policy add-scc-to-user anyuid -z ${LAB_NAME}-sa
# oc patch dc/elvis --patch '{"spec":{"template":{"spec":{"serviceAccountName": "elvis-sa"}}}}'

# passo-01
oc patch dc ${LAB_NAME} -p "spec:
  template:
    spec:
      serviceAccountName: ${LAB_NAME}"

# passo-02
oc patch dc ${LAB_NAME} -p "spec:
  template:
    spec:
      serviceAccountName: ${LAB_NAME}-sa"

printf "\n\thttps://`oc get route ${LAB_NAME} -o template --template {{.spec.host}}/api/hello`\n"
```



## labm004

### setup

```shell
GITHUB_USER=jovemfelix
LAB_NAME=roberto
oc new-app --name $LAB_NAME https://github.com/$GITHUB_USER/DO288-apps --context-dir post-commit
oc expose svc/$LAB_NAME

LAB_NAME=carlos
oc new-app --name $LAB_NAME https://github.com/$GITHUB_USER/DO288-apps --context-dir builds-for-managers
oc expose svc/$LAB_NAME

oc set build-hook bc/roberto --post-commit --command -- \
    bash -c "curl -s -S -i -X POST http://builds-for-managers-${RHT_OCP4_DEV_USER}-post-commit.${RHT_OCP4_WILDCARD_DOMAIN}/api/builds -f -d 'developer=\${DEVELOPER}&git=\${OPENSHIFT_BUILD_SOURCE}&project=\${OPENSHIFT_BUILD_NAMESPACE}'"

```

### diagnostic



# Troubleshooting Java applications on OpenShift

```shell
oc new-app --name=myapp jboss-webserver30-tomcat8-openshift:1.3~https://github.com/openshiftdemos/os-sample-java-web.git
```



```shell
oc create --force -f https://raw.githubusercontent.com/jboss-fuse/application-templates/master/quickstarts/spring-boot-camel-template.json

oc new-project spring-boot-cxf-jaxrs --display-name="spring-boot-cxf-jaxrs" --description="spring-boot-cxf-jaxrs"

oc new-app --template=s2i-fuse75-spring-boot-camel -p GIT_REPO="https://github.com/fabric8-quickstarts/spring-boot-cxf-jaxrs.git" -p GIT_REF=""

oc expose dc s2i-springboot-camel --port=8080 --generator=service/v1
oc expose svc s2i-springboot-camel
```



# Referências Internas

1. [Consolidated](https://access.redhat.com/articles/2913431) Troubleshooting Article OpenShift Container Platform 3.x
   1. *Solutions*: Troubleshooting OpenShift Container Platform [3.x](https://access.redhat.com/solutions/1542293): Basics
2. OpenShift 4.x - Troubleshooting Application Pods with the OpenShift Web [Console](https://role.rhu.redhat.com/rol-rhu/app/seminar/exps174-1)
3. OpenShift 4.x - Troubleshooting [Quick](https://access.redhat.com/articles/3787381) Reference

# Referências Públicas

1. Troubleshooting OpenShift Clusters and [Workloads](https://towardsdatascience.com/troubleshooting-openshift-clusters-and-workloads-382664018935)
2. [23](https://medium.com/faun/kubectl-commands-cheatsheet-43ce8f13adfb) Advanced kubectl commands
3. kubectl [Cheat](https://kubernetes.io/docs/reference/kubectl/cheatsheet/) Sheet
4. [Types](https://www.bluematador.com/blog/kubernetes-events-explained) of Kubernetes Events
5. Oficial [documentation](https://docs.openshift.com/container-platform/3.11/dev_guide/events.html) Events 
6. Troubleshooting [Java applications](https://developers.redhat.com/blog/2017/08/16/troubleshooting-java-applications-on-openshift/) on OpenShift
7. [Livro](https://assets.openshift.com/hubfs/pdfs/DevOps_with_OpenShift.pdf?hsLang=en-us) DevOps with OpenShift
8. [Jolokia](https://developers.redhat.com/blog/2016/03/30/jolokia-jvm-monitoring-in-openshift/) JVM Monitoring in OpenShift
9. Environment [health](https://docs.openshift.com/container-platform/3.11/day_two_guide/environment_health_checks.html) checks


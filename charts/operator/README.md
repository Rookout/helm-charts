# Rookout

[Rookout](http://rookout.com/) gets data from your live code, as it runs. Extract any piece of data from your code and pipeline it anywhere, in realtime, even if you’d never thought about it beforehand or created any instrumentation to collect it.

## Introduction

This chart installs [Rookout's k8s Operator](https://docs.rookout.com/docs/k8s-operator-setup.html) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.9+ with Beta APIs enabled

## Installing the Chart using helm

To install the chart with the release name `rookout-operator`:

Add rookout's helm repo :
```
helm repo add rookout https://helm-charts.rookout.com
helm repo update
```

### Helm 2 

Apply CRDs with kubectl
```
kubectl apply -f ./crds/custom_resource_definition.yaml
```

Then install the chart
```
helm install --name rookout-operator rookout/operator -f values.yaml
```

### Helm 3

Install chart (CRDs will be applied by helm3 automatically)
```
helm install rookout-operator rookout/operator -f values.yaml
```

## Updating configuration and redeploy with helm
Modify the  [values.yaml](./values.yaml)

Then apply the changes with :
```
helm upgrade --install rookout-operator rookout/operator -f values.yaml
```

## Installation without helm
If you're not using helm with your kubernetes cluster, you'll still be able to install the controller. Helm will be needed to be installed locally just to create the yaml file from the templates.

1.  Install helm locally: https://helm.sh/docs/intro/install/ 
2.  Clone this repository and `cd charts/operator`
3.  run ```helm template . -f values.yaml > rookout-operator.yaml```
4.  A generation of the yamls will be piped right to a single yaml file called `rookout-operator.yaml`
5.  Run `kubectl apply -f rookout-operator.yaml`


## Uninstalling the Chart

To uninstall/delete the `rookout-operator` deployment:

```
helm delete rookout-operator
```

Or, if you're not using helm, (use the yaml you've created with `helm template` command):
```
kubectl delete -f rookout-operator.yaml
```

Those commands removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Rookout Operator chart and their default values (See [values.yaml](./values.yaml) for example values).

|            Parameter                      |              Description                   | Default  | Required 
| ----------------------------------------- | -------------------------------------------| ---------| --------
| `image.repository`                        | Operator image repo                        | None     | Yes
| `image.tag`                               | Operator image tag                         | None     | Yes
| `image.pullPolicy`                        | Operator image pull policy                 | Always   | Yes
| `operator.matchers`                       | see matchers explanation below             | None     | Yes
| `operator.init_container.image`           | Init container image repo                  | None     | Yes
| `operator.init_container.tag`             | Init container image tag                   | None     | Yes
| `operator.init_container.pullPolicy`      | Init container image pull policy           | Always   | Yes
| `operator.resources.requests.cpu`         | operator CPU allocation request            | 30m      | Yes
| `operator.resources.requests.memory`      | operator memory allocation request         | 31Mi     | Yes
| `operator.resources.limits.cpu`           | operator CPU limit                         | 4000m    | Yes
| `operator.resources.limits.memory`        | operator memory limit                      | 1024Mi   | Yes


`operator.matchers` must be populated in [values.yaml](./values.yaml) file

Matchers guide the operator which deployments need to be patched

Each matcher can contain the following constraints (one or more):
- deployment - substring of deployment name (Deployment.metadata.name)
- container - substring of container name (Deployment.Specs.Template.Specs.Containers[].name)
- namespace - substring of namespace name 
- labels - list of Key/value which should match on deployment labels (Deployment.metadata.labels)

Each matcher should have ROOKOUT_TOKEN environment variable defined in its `env_vars` section

If container matcher not supplied the operator will install rookout agent on all the containers in the deployment.
 
Example :

The following matcher will match on deployments that contain "test_automation" in their name
,have a container with the string "frontend" in its name and contain the label "env:production"

The matcher tells the operator to set "ROOKOUT_TOKEN" environment variable on every matched container.   

```
matchers:
    - deployment: "test_automation"
      container: "frontend"
      namespace: "production"
      labels:
         - env: "production"
      env_vars:
          - name: "ROOKOUT_TOKEN"
            value: "<YOUR TOKEN>"
``` 

## Important log lines

How to see the operator logs :
```
kubectl -n rookout logs -f deployment/rookout-controller-manager --all-containers=true --since=10m
```

The operator is ready for patching deployments :
```
Operator configuration updated
```
If the logline above does not exist, it means that no operator matchers were supplied.. 
Make sure at least one matcher is defined in [values.yaml](./values.yaml) under the operator.matchers section.


The Rookout agent was successfully installed :
```
Adding rookout agent to container <container name> of deployment <deployment name> in <namespace name> namespace"
Deployment <deployment name> patched successfully
```


# Rookout

[Rookout](http://rookout.com/) gets data from your live code, as it runs. Extract any piece of data from your code and pipeline it anywhere, in realtime, even if you’d never thought about it beforehand or created any instrumentation to collect it.

## Introduction

This chart installs [Rookout's k8s Operator](https://docs.rookout.com/docs/k8s-operator-setup.html) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.9+ with Beta APIs enabled

## Installing the Chart using helm

To install the chart with the release name `my-release`:

Helm 2  

First, apply CRDs with kubectl
```
kubectl apply -f ./crds/custom_resource_definition.yaml
```

Then install the chart
```
helm install --name my-release rookout/operator -f values.yaml
```

Helm 3

Install chart (CRDs will be applied by helm3 automatically)
```
helm install my-release rookout/operator -f values.yaml
```

## Updating configuration and redeploy with helm
Modify the  [values.yaml](./values.yaml)

Then apply the changes with :
```
helm upgrade --install my-release rookout/operator -f values.yaml
```

## Installation without helm
If you're not using helm with your kubernetes cluster, you'll still be able to install the controller. Helm will be needed to be installed locally just to create the yaml file from the templates.

1.  Install helm locally: https://helm.sh/docs/intro/install/ 
2.  Clone this repository and `cd charts/operator`
3.  run (helm 2+3)```helm template . -f values.yaml > rookout-operator.yaml```
4.  A generation of the yamls will be piped right to a single yaml file called `rookout-operator.yaml`
5.  Run `kubectl apply -f rookout-operator.yaml`


## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```
helm delete my-release
```

Or, if you're not using helm:
```
kubectl delete -f rookout-operator.yaml
```

Those commands removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters and their default values.

|            Parameter                      |              Description                 |                          Default                        | Required |
| ----------------------------------------- | ---------------------------------------- | ------------------------------------------------------- | ---------|
| `operator.matchers`                       | List of matchers (see matchers section below)         | (None)                                     | Yes      |


## Matchers

Matchers guide the operator which deployments desired to be patched

Each matcher can contain the following constraints (one or more):
- deployment - substring of deployment name (Deployment.metadata.name)
- container - substring of container name (Deployment.Specs.Template.Specs.Containers[].name)
- labels - list of Key/value which should match on deployment labels (Deployment.metadata.labels)

Example :
The following matcher will match on deployment named "test_automation" which contains a container "frontend"  
and the label "env:production"

The matcher will set "ROOKOUT_TOKEN" environment variable on matched containers

ROOKOUT_TOKEN environment variable required for each matcher  

Take a look at [values.yaml](./values.yaml) for full example reference
```
matchers:
    - deployment: "test_automation"
      container: "frontend"
      labels:
         - env: "production"
      env_vars:
          - name: "ROOKOUT_TOKEN"
            value: "<YOUR TOKEN>"
``` 

## Check deployment status

Get all deployment logs :
```
kubectl -n rookout logs -f deployment/rookout-controller-manager --all-containers=true --since=10m
```

You should see the following log message :
```
Operator configuration updated
```


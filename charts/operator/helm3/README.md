# Rookout

[Rookout](http://rookout.com/) gets data from your live code, as it runs. Extract any piece of data from your code and pipeline it anywhere, in realtime, even if you’d never thought about it beforehand or created any instrumentation to collect it.

## TL;DR;

```bash
helm repo add rookout https://helm-charts.rookout.com
helm repo update
helm install --name my-release rookout/operator --set operator.token=YOUR_ORGANIZATIONAL_TOKEN
```

## Introduction

This chart installs [Rookout's k8s Operator](https://docs.rookout.com/docs/k8s-operator-setup.html) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.9+ with Beta APIs enabled

## Installing the Chart using helm

To install the chart with the release name `my-release`:

```bash
$ helm install my-release rookout/operator --set operator.token=YOUR_ORGANIZATIONAL_TOKEN
```

The command deploys Rookout's k8s operator on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Installation without helm
If you're not using helm with your kubernetes cluster, you'll still be able to install the controller. Helm will be needed to be installed locally just to create the yaml file from the templates.

1.  Install helm locally: https://helm.sh/docs/intro/install/ 
2.  Clone this repository and `cd charts/operator`
3.  run ``` helm template . --set operator.token=YOUR_ORGANIZATIONAL_TOKEN > rookout-operator.yaml```
4.  A generation of the yamls will be piped right to a single yaml file called `rookout-operator.yaml`
5.  Run `kubectl apply -f rookout-operator.yaml`


## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

or, if you're not using helm:
```bash
$ kubectl delete -f rookout-operator.yaml
```

Those commands removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters and their default values.

|            Parameter                      |              Description                 |                          Default                        | 
| ----------------------------------------- | ---------------------------------------- | ------------------------------------------------------- |
| `operator.token`                          | Token to authentication with Rookout's SaaS         | (None)
| `operator.matchers`                       | List of matchers (see matchers section below)         | (None)


## Matchers

Matchers guide the operator which deployments desired to be patched

Each matcher can contain the following constraints (one or more):
- deployment - substring of deployment name (Deployment.metadata.name)
- container - substring of container name (Deployment.Specs.Template.Specs.Containers[].name)
- labels - list of Key/value which should match on deployment labels (Deployment.metadata.labels)

Example :
The following matcher will match on deployment named "test_automation" which contains a container "frontend"  
and the label "env:production"
```
matchers:
    - deployment: "test_automation"
      container: "frontend"
      labels:
         - env: "production"
``` 

The above parameters map to the env variables defined in [rookout/operator](https://docs.rookout.com/docs/k8s-operator-setup.html).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm repo add rookout https://helm-charts.rookout.com
helm repo update
helm install --name my-release \
  --set operator.token=YOUR_ORGANIZATIONAL_TOKEN \
    rookout/operator
```

The above command sets the Rookout token to your organizational token.

> **Tip**: You can use the default [values.yaml](values.yaml)

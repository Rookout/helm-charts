# Rookout

[Rookout](http://rookout.com/) gets data from your live code, as it runs. Extract any piece of data from your code and pipeline it anywhere, in realtime, even if you’d never thought about it beforehand or created any instrumentation to collect it.

## TL;DR;

```bash
helm repo add rookout https://helm-charts.rookout.com
helm repo update
helm install --name my-release rookout/controller --set controller.token=YOUR_ORGANIZATIONAL_TOKEN
```

## Introduction

This chart bootstraps a [Rookout Controller](https://docs.rookout.com/docs/agent-setup.html) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.9+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-controller rookout/controller --set rookout.token=YOUR_ORGANIZATIONAL_TOKEN
```

The command deploys Rookout on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-controller` deployment:

```bash
$ helm delete my-controller
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Rookout Router chart and their default values.

|            Parameter                      |              Description                 |                          Default                        | 
| ----------------------------------------- | ---------------------------------------- | ------------------------------------------------------- |
| `controller.token`                           | Rookout organizational token             | `Nil` You must provide your own token                   |  
| `controller.listenAll`                       | Configuring the Controller to listen on all addresses instead of only localhost.                      | `False` Listens only on localhost |
| `controller.resources.requests.cpu`          | CPU resource requests                    | `30m`                                                   |
| `controller.resources.limits.cpu`            | CPU resource limits                      | `4000m`                                                 |
| `controller.resources.requests.memory`       | Memory resource requests                 | `32Mi`                                                  |
| `controller.resources.limits.memory`         | Memory resource limits                   | `1024Mi`                                                |
| `controller.internalResources.limits.cpu`    | Rookout Controller internal cpu limit, measured in number of full cpus     | `4`                    |
| `controller.internalReources.limits.memory`  | Rookout Controller internal memory limit, measured in Mb                 | `1024`                   |
| `image.registry`                          | Rookout image registry                   | `docker.io`                                             |
| `image.repository`                        | Rookout image name                       | `rookout/controller`                                         |
| `image.tag`                               | Rookout image tag                        | `{VERSION}`                                             |
| `image.pullPolicy`                        | Image pull policy                        | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `image.pullSecrets`                       | Specify image pull secrets               | `nil`                                                   |


The above parameters map to the env variables defined in [rookout/controller](https://docs.rookout.com/docs/agent-setup.html). For more information please refer to the [rookout/controller](https://hub.docker.com/r/rookout/agent/) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm repo add rookout https://helm-charts.rookout.com
helm repo update
helm install --name my-controller \
  --set controller.token=YOUR_ORGANIZATIONAL_TOKEN,listenAll=False \
    rookout/controller
```

The above command sets the Rookout Controller token to your organizational token. Additionally, it sets the listenAll to `False`.

> **Tip**: You can use the default [values.yaml](values.yaml)

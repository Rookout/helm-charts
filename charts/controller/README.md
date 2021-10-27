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

- Kubernetes 1.9+ with Beta APIs enabled **(if ingress is enabled, requires Kubernetes 1.19+)**

## Installing the Chart using helm

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-controller rookout/controller --set controller.token=YOUR_ORGANIZATIONAL_TOKEN
```

The command deploys Rookout on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Installation without helm
If you're not using helm with your kubernetes cluster, you'll still be able to install the controller. Helm will be needed to be installed locally just to create the yaml file from the templates.

1.  Install helm locally: https://helm.sh/docs/intro/install/ 
2.  Clone this repository and `cd charts/controller`
3.  run ``` helm template . --set controller.token=YOUR_ORGANIZATIONAL_TOKEN --name=rookout > rookout-controller.yaml```
4.  A generation of the yamls will be piped right to a single yaml file called `rookout-controller.yaml`
5.  Run `kubectl apply -f rookout-controller.yaml`


## Uninstalling the Chart

To uninstall/delete the `my-controller` deployment:

```bash
$ helm delete my-controller
```

or, if you're not using helm:
```bash
$ kubectl delete -f rookout-controller.yaml
```

Those commands removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

### Server Modes

The controller runs with one of 2 modes (controller.serverMode):

* **TLS** - You will need to create the following secret & configmap in your k8s cluster :
  1. Create configmapName for the TLS certificate : `kubectl create configmap rookout-tls-cert --from-file=tls.crt=<path to cert file>`  
  1. Create secret for the TLS private-key : `kubectl create secret generic rookout-tls-key --from-file=tls.key=<path to key file>`

* **PLAIN** - If you want to use your own ingress and enforce SSL validation not on application-level, you can set to this mode and configure your own ingress (with SSL termination) to receive requests and route them to the controller's port.

The following table lists the configurable parameters of the Rookout Router chart and their default values.

|            Parameter                      |              Description                 |                          Default                        | 
| ----------------------------------------- | ---------------------------------------- | ------------------------------------------------------- |
| `controller.serverMode`                   | TLS / PLAIN                    | PLAIN (required)
| `controller.token`                           | Rookout organizational token             | `Nil` You must provide your own token                   |  
| `controller.tokenFromSecret.name`                 | Secret ref in which the Rookout token resides  | `Nil` You must provide your own secret (Optional if setting the token using controller.token)                   |  
| `controller.tokenFromSecret.key`                 | Key of the secret in which the Rookout token resides  | `Nil` You must provide your own secret (Optional if setting the token using controller.token)                   |  
| `ingress.enabled` | Creates a simple ingress that will direct a defined hostname to the controller. Note that this ingress does not consist of cert-manager | `False` | 
| `ingress.host` | Hostname set to the controller | (none) | 
| `controller.listenAll`                       | Configuring the Controller to listen on all addresses instead of only localhost.                      | `False` Listens only on localhost |
| `controller.port`                       | On which port to listen for connections                       | 7488 |
| `controller.labels`                       | Additional labels for the Deployment | (None)  |
| `controller.proxy`                       | HTTPS proxy URL. example: https://127.0.0.1:9090 | (None) |
| `controller.proxyUsername`                       | Username for the proxy server | (None) |
| `controller.proxyPassword`                       | Password for the proxy server | (None) |
| `controller.proxyPasswordFromSecret.name`        | Secret name of the proxy password (instead of `proxyPassword`) | (None) |
| `controller.proxyPasswordFromSecret.key`        | Secret key of the proxy password (instead of `proxyPassword`) | (None) |
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
| `serviceAccount.name` | Optional name for the service account | (none) |
| `podAnnotations` | Annotations for the controller k8s pod | (none) |
| `service.annotations` | Annotations for the controller k8s service | (none) |
| `affinity` | deployment affinity (optional) | (none) |
| `tolerations` | deployment tolerations (optional) | (none) |
| `nodeSelector` | deployment nodeSelector (optional) | (none) |
| `controller.datastore_no_ssl_verif` | skip SSL cert verification when connecting to datastore | false |


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

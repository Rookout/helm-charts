# Rookout Hybrid Architecture

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Rookout's hybrid (on-premise) architecture components - ETL Controller and Datastore

For more information:

* Controller - <https://docs.rookout.com/docs/etl-controller-intro>

* Datastore - <https://docs.rookout.com/docs/dop-intro>

## Quick start

### Adding the Rookout repository

First, run the following:

```commandline
helm repo add rookout https://helm-charts.rookout.com
helm repo update
```

### Installation

[This yaml file](https://github.com/Rookout/helm-charts/tree/master/charts/rookout-hybrid/examples/nginx_lets_encrypt.yaml) shows a basic example configuration using Nginx + cert-manager + Let's Encrypt.

To use it, modify the contents of the example yaml file to match your configuration, and then run:

```commandline
helm upgrade --install rookout rookout/rookout-hybrid -f ingerss_example.yaml
```

### Controller only installation

```commandline
helm upgrade --install rookout rookout/rookout-hybrid \
    --set rookout.token=<ROOKOUT_TOKEN> \
    --set datastore.enabled=false
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| controller.affinity | object | `{}` | Assign custom [affinity] rules to the deployment |
| controller.enabled | bool | `true` | Whether to deploy an ETL Controller |
| controller.extraEnv | list | `[]` | Additional environment variables for Rookout's controller. A list of name/value maps. |
| controller.extraLabels | object | `{}` | Deployment extra labels |
| controller.fullnameOverride | string | `""` | String to fully override "controller.fullname" template |
| controller.image.name | string | `"controller"` | Rookout's controller image name |
| controller.image.pullPolicy | string | `"Always"` | Rookout's controller image pull policy |
| controller.image.repository | string | `"rookout"` | Rookout's controller public dockerhub repo |
| controller.image.tag | string | `"latest"` | Rookout's controller image tag |
| controller.ingress.annotations | object | `{}` | Controller ingress annotations |
| controller.ingress.className | string | `""` | Controller ingress class name |
| controller.ingress.enabled | bool | `false` | Enable controller ingress support |
| controller.ingress.hosts | list | `[{"host":"controller.rookout.example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}]` | Controller ingress hosts # Hostnames must be provided if Ingress is enabled. |
| controller.ingress.tls | list | `[]` | Controller ingress tls |
| controller.nameOverride | string | `""` | String to partially override "controller.fullname" template |
| controller.nodeSelector | object | `{}` | [Node selector] |
| controller.podAnnotations | object | `{}` | Annotations to be added to the Controller pods |
| controller.podSecurityContext | object | `{"fsGroup":5000,"runAsGroup":5000,"runAsUser":5000}` | Security Context to set on the pod level |
| controller.replicaCount | int | `1` | Rookout's controller number of replicas |
| controller.resources | object | `{"limits":{"cpu":2,"memory":"4096Mi"},"requests":{"cpu":1,"memory":"512Mi"}}` | Resource limits and requests for the controller pods. |
| controller.securityContext | object | `{}` | Security Context to set on the container level |
| controller.service.port | int | `80` | Service port For TLS mode change the port to 443 |
| controller.service.type | string | `"ClusterIP"` | Sets the type of the Service |
| controller.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| controller.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| controller.serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| controller.tolerations | list | `[]` | [Tolerations] for use with node taints |
| datastore.affinity | object | `{}` | Assign custom [affinity] rules to the deployment |
| datastore.enabled | bool | `true` | whether to deploy a Datastore |
| datastore.extraEnv | list | `[]` | Additional environment variables for Rookout's datastore. A list of name/value maps. |
| datastore.extraLabels | object | `{}` | Deployment extra labels |
| datastore.fullnameOverride | string | `""` | String to fully override "datastore.fullname" template |
| datastore.image.name | string | `"data-on-prem"` | Rookout's Datastore image name |
| datastore.image.pullPolicy | string | `"Always"` | Rookout's Datastore image pull policy |
| datastore.image.repository | string | `"rookout"` | Rookout's Datastore public dockerhub repo |
| datastore.image.tag | string | `"latest"` | Rookout's Datastore image tag |
| datastore.inMemoryDb | bool | `true` | Whether to create a PVC or use in-memory storage (recommended). https://docs.rookout.com/docs/dop-config#in-memory-database |
| datastore.ingress.annotations | object | `{}` | Datastore ingress annotations |
| datastore.ingress.className | string | `""` | Datastore ingress class name |
| datastore.ingress.enabled | bool | `false` | Enable datastore ingress support |
| datastore.ingress.hosts | list | `[{"host":"datastore.rookout.example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}]` | Datastore ingress hosts # Hostnames must be provided if Ingress is enabled. |
| datastore.ingress.tls | list | `[]` | Datastore ingress tls |
| datastore.nameOverride | string | `""` | String to partially override "datastore.fullname" template |
| datastore.nodeSelector | object | `{}` | [Node selector] |
| datastore.podAnnotations | object | `{}` | Annotations to be added to the Datastore pods |
| datastore.podSecurityContext | object | `{"fsGroup":5000,"runAsGroup":5000,"runAsUser":5000}` | Security Context to set on the pod level |
| datastore.resources | object | `{"limits":{"cpu":2,"memory":"4096Mi"},"requests":{"cpu":2,"memory":"4096Mi"}}` | Resource limits and requests for the datastore pods. |
| datastore.securityContext | object | `{}` | Security Context to set on the container level |
| datastore.service.port | int | `80` | Service port For TLS mode change the port to 443 |
| datastore.service.type | string | `"ClusterIP"` | Sets the type of the Service |
| datastore.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| datastore.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| datastore.serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| datastore.tolerations | list | `[]` | [Tolerations] for use with node taints |
| imagePullSecrets | list | `[]` | Secrets with credentials to pull images from a private registry. Registry secret names as an array. |
| rookout.controllerTLSSecretName | string | `""` | Rookout's controller TLS secert used when rookout.serverMode: "TLS" The components expect to find "tls.key" and "tls.crt" keys in the secert |
| rookout.datastoreTLSSecretName | string | `""` | Rookout's datastore TLS secert used when rookout.serverMode: "TLS" The components expect to find "tls.key" and "tls.crt" keys in the secert |
| rookout.serverMode | string | `"PLAIN"` | Rookout's components communication mode, PLAIN or TLS. For TLS, please check rookout.controllerTLSSecretName and rookut.datastoreTLSSecretName |
| rookout.token | string | `nil` | using rookout.token will create secret that mounts as ENV variable into the pods. |
| rookout.tokenExistingSecret | string | `nil` | NOTICE: the key of the secret should be named `token` |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

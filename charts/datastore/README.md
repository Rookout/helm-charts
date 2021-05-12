# Rookout data-on-prem

To set up the Rookout data-on-prem solution, contact us at support@rookout.com

### Introduction

The Rookout data-on-prem solution allows you to store your Rookout data on-premises, while still using the standard Rookout web UI.


### Installation using helm

```bash
helm repo add rookout https://helm-charts.rookout.com
helm repo update
helm install --name my-release rookout/datastore --set datastore.serverMode=<YOUR_TLS_MODE> --set datastore.token=<YOUR_ORGANIZATION_TOKEN>
```

### Installation without helm
If you're not using helm with your kubernetes cluster, you'll still be able to install the datastore. Helm will be needed to be installed locally just to create the yaml file from the templates.

1.  Install helm locally: https://helm.sh/docs/intro/install/ 
2.  Clone this repository and `cd charts/datastore`
3.  run ``` helm template . --set datastore.serverMode=<YOUR_TLS_MODE> --set datastore.token=<YOUR_ORGANIZATION_TOKEN> --name=rookout > rookout-datastore.yaml```
4.  A generation of the yamls will be piped right to a single yaml file called `rookout-datastore.yaml`
5.  Run `kubectl apply -f rookout-datastore.yaml`

### Server Modes

The data-on-prem solution runs with one of 3 modes (datastore.serverMode):

* **TLS** - (opens port 443) If you have your own certificate that resides also for your teammates browser, you will need can configmap with the certificare (key "cert.pem") and supply the configmapName, with that the key to the cert in a secret (key "key.pem") and supply the secretName.
  1. Create configmapName for the TLS certificate : `kubectl create configmap rookout-tls-cert --from-file=cert.pem=<path to cert file>`  
  1. Create secret for the TLS private-key : `kubectl create secret generic rookout-tls-key --from-file=key.pem=<path to key file>`
* **AUTOTLS** - (opens port 443 + 80) If you don't want to user your own certificate, this mode will fetch a certificate automaticllay using [LetsEncrypt](https://letsencrypt.org/). As a prerequisites you must set a hostname in an valid DNS for the data-on-prem's external IP and set that hostname in `datastore.autoTlsDomain` for the certificate to vouche for that hostname.

* **PLAIN** - (open port 80) if you want to use your own ingress and enforce SSL validation not on application-level, you can set to this mode and configure your own ingress to receive requests at port 443 and direct with to the data-on-prem on port 80.

### Configuration
| Parameter | Description |
| ------ | ------ |
| datastore.serverMode | Can have only 3 values: **AUTOTLS**, **TLS**, **PLAIN** (required)|
| datastore.servicePort | service external port (default=80). See guidelines below this table for Ingress service |
| datastore.logging.enabled | Whether logs should be sent to Rookout. If you decide to enable logging, you must specify your Rookout token with `token` or `tokenFromSecret` parameters |
| datastore.token | Your organization token. This is the same token as that used by your Rookout ETL controller |
| datastore.tokenFromSecret.name| Secret ref in which the Rookout token resides |
| datastore.tokenFromSecret.key| Key of the secret in which the Rookout token resides |
| datastore.dopContainerPort| Main container port, default: 8080 |
| datastore.letsEncryptContainerPort| Let's encrypt container port (required on AUTOTLS mode), default: 9090 |
| datastore.inMemoryDb| Use in-memory db instead of file-system, default: false |
| datastore.autoTlsDomain | Only when using AUTOTLS mode, the domain name the server will request a certificate for using [LetsEncrypt](https://letsencrypt.org/). |
| datastore.tlsKeySecretName| Only when using TLS mode, Secret name which has a key named "key.pem" whose value is the private key |
| datastore.tlsCertificateConfigmapName| Only when using TLS mode, Configmap name which has a key named "cert.pem" whose value is the certificate |
| datastore.labels                       | Additional labels for the Deployment |
| datastore.urlPrefix                    | URL prefix for datastore URLs (optional) |
| service.type | The component's service type, further explaination [here](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types)|
| service.loadBalancerIP | Only when using `loadBalancer` as service type, that's an external IP that you can set for your component, further explaination [here](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types)|
| service.annotations | Annotations for the datastore k8s service |
| serviceAccount.name | Name | Optional name for the service account |
| podAnnotations | Annotations for the datastore k8s pod |
| pvc.storageClassName | the persistentVolumeClaim's storageClassName, defaults to `nil` |
| pvc.volumeSize | the persistentVolumeClaim's requested volume size, defaults to 10Gi |) |
| affinity | deployment affinity (optional) |
| tolerations | deployment tolerations (optional) |
| nodeSelector | deployment nodeSelector (optional) |
| service.annotations | Annotations for the data-on-prem k8s service (optional) |
| resources.requests.cpu        | CPU resource requests (default: 1) |
| resources.limits.cpu         | CPU resource limits (default: 2)|
| resources.requests.memory       | Memory resource requests (default: 1G) |
| resources.limits.memory        | Memory resource limits (default: 4G) |


### Ingress guidelines
- Some ingresses requires special annotation for SSL terminations whihc depends on the kubernets cluster provider.
- When ingress + SSL is used the data-on-prem serverMode should be in *PLAIN* because it gets plain HTTP from the ingress.
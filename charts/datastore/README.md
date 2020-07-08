# Rookout data-on-prem

To set up the Rookout data-on-prem solution, contact us at support@rookout.com

### Introduction

The Rookout data-on-prem solution allows you to store your Rookout data on-premises, while still using the standard Rookout web UI.


### Short version installation

```bash
helm repo add rookout https://helm-charts.rookout.com
helm repo update
helm install --name my-release rookout/datastore--set datastore.serverMode=<YOUR_TLS_MODE> --set datastore.loggingToken=<YOUR_ORGANIZATION_TOKEN>
```

### Longer version...

The data-on-prem solution runs with one of 3 modes (datastore.serverMode):

* **TLS** - (opens port 443) If you have your own certificate that resides also for your teammates browser, you will need can configmap with the certificare (key "cert.pem") and supply the configmapName, with that the key to the cert in a secret (key "key.pem") and supply the secretName.

* **AUTOTLS** - (opens port 443 + 80) If you don't want to user your own certificate, this mode will fetch a certificate automaticllay using [LetsEncrypt](https://letsencrypt.org/). As a prerequisites you must set a hostname in an valid DNS for the data-on-prem's external IP and set that hostname in `datastore.autoTlsDomain` for the certificate to vouche for that hostname.

* **PLAIN** - (open port 80) if you want to use your own ingress and enforce SSL validation not on application-level, you can set to this mode and configure your own ingress to receive requests at port 443 and direct with to the data-on-prem on port 80.

### Configuration
| Parameter | Description |
| ------ | ------ |
| datastore.serverMode | Can have only 3 values: **AUTOTLS**, **TLS**, **PLAIN**|
| datastore.loggingToken | Your organization token. This is the same token as that used by the Rookout SDK. |
| datastore.autoTlsDomain | Only when using AUTOLS mode, the domain name the server will request a certificate for using [LetsEncrypt](https://letsencrypt.org/). |
| datastore.tlsKeySecretName| Only when using TLS mode, Secret name which has a key named "key.pem" whose value is the private key |
| datastore.tlsCertificateConfigmapName| Only when using TLS mode, Configmap name which has a key named "cert.pem" whose value is the certificate |
| service.type | The component's service type, further explaination [here](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types)|
| service.loadBalancerIP | Only when using `loadBalancer` as service type, that's an external IP that you can set for your component, further explaination [here](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types)|
| pvc.storageClassName | the persistentVolumeClaim's storageClassName, defaults to `nil` |
| pvc.volumeSize | the persistentVolumeClaim's requested volume size, defaults to 10Gi |) |

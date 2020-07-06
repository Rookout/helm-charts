# Rookout data-on-prem

Before you continue, our recommandation, just to make things super clear, is to talk to us at support@rookout.com for help regarding installing, troubleshooting, prices or anything regarding rookout.

### Introduction

Rookout data-on-prem lets you protect your own data, saving the messages we get from your application right on your premise.
Those messages are served to you in [app.rookout.com](https://app.rookout.com/)


### Short version installation

```bash
helm repo add rookout https://helm-charts.rookout.com
helm repo update
helm install --name my-release rookout/data-on-prem --set datastore.serverMode=<YOUR_TLS_MODE>
```

### Longer version...

In order for it to be accesible by [app.rookout.com](https://app.rookout.com/) the data-on-prem must be able to receive requests via HTTPS port. to ensure usage of verified certs, it must be installed with one of three modes:

* **TLS** - (opens port 443) If you have your own certificate that resides also for your teammates browser, you will need can configmap with the certificare (key "cert.pem") and supply the configmapName, with that the key to the cert in a secret (key "key.pem") and supply the secretName.

* **AUTOTLS** - (opens port 443 + 80) If you don't want to user your own certificate, this mode will fetch a certificate automaticllay using [LetsEncrypt](https://letsencrypt.org/). As a prerequisites you must set a hostname in an valid DNS for the data-on-prem's external IP and set that hostname in `datastore.autoTlsDomain` for the certificate to vouche for that hostname.

* **PLAIN** - (open port 80) if you want to use your own ingress and enforce SSL validation not on application-level, you can set to this mode and configure your own ingress to receive requests at port 443 and direct with to the data-on-prem on port 80.

### Configuration
| Parameter | Description |
| ------ | ------ |
| datastore.serverMode | Can have only 3 values: **AUTOTLS**, **TLS**, **PLAIN**|
| datastore.autoTlsDomain | Only when using AUTOLS mode, that's the domain that the cert will vouche for. |
| datastore.tlsKeySecretName| Only when using TLS mode, that's the secret nane which should hold the cert's key (key should be "key.pem") |
| datastore.tlsCertificateConfigmapName| Only when using TLS mode, that's the configMap nane which should hold the cert itself (key should be "cert.pem") |
| service.type | The component's service type, further explaination [here](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types)|
| service.loadBalancerIP | Only when using `loadBalancer` as service type, that's an external IP that you can set for your component, further explaination [here](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types)|
| pvc.storageClassName | the persistentVolumeClaim's storageClassName, defaults to `nil` |
| pvc.volumeSize | the persistentVolumeClaim's requested volume size, defaults to 10Gi |) |
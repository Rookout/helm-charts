# Rookout Helm Charts Repository

## How to install a chart from this repository

- Add the repository to helm  
`helm repo add rookout https://helm-charts.rookout.com`

- Update helm repository listing  
`helm repo update`

- Install the chart  
`helm install rookout/CHART_NAME`


## Available charts

[controller](https://github.com/rookout/helm-charts/tree/master/charts/controller) - Check out our [Rookout Controller Documentation](https://docs.rookout.com/docs/etl-controller-intro/)
(This chart no longer under active development.)

[datastore](https://github.com/rookout/helm-charts/tree/master/charts/datastore) - Controller required (This chart no longer under active development.)

[rookout](https://github.com/rookout/helm-charts/tree/master/charts/rookout) - Rookout's hybrid deployment components (ETL Controller + Datastore)

---------------------------------------------------------------

[LICENSE](https://github.com/rookout/helm-charts/blob/master/LICENSE)

## 1. Deploy Prometheus

```zsh
kubectl apply -f ./deployments/monitoring/deployment-prometheus.yaml
```

## 2. Deploy Node Exporter

```zsh
kubectl apply -f ./deployments/monitoring/deployment-node-exporter.yaml
```

## 3. Deploy Grafana

### 3.1 Deploy Grafana Dashboards

```zsh
kubectl apply -f ./deployments/monitoring/configmap-grafana-dashboards.yaml
```

### 3.2 Deploy Grafana

```zsh
kubectl apply -f ./deployments/monitoring/deployment-grafana.yaml
```

### 3.3 Port Forwarding Grafana

```zsh
kubectl port-forward -n bd-bd-stud-olmoe22 deployment/grafana 3000:3000
```

## Metrics Server (requires k8s admin permissions)

### Download the Metrics Server components.yaml file

```zsh
curl -LO https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

### Apply the Metrics Server components.yaml file

```zsh
kubectl apply -f ./deployments/monitoring/metrics-server-deployment.yaml
```

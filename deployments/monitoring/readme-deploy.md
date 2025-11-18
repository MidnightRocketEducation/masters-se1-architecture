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

## Send Test Requests to prod-line-sys-svc

```zsh
# Send 500 requests per second until 300000 requests are reached (takes 600 seconds)
for i in $(seq 1 300000); do
  curl -X POST http://prod-line-sys-svc:8080/api/v1/smart-buffer-tanks/temperature-measurement \
    -H "Content-Type: application/json" \
    -d "{\"temperature\":2,\"timestamp\":\"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\"}" &
  if (( $i % 500 == 0 )); then sleep 1; fi
done
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

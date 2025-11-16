### Deploy Promtheus
```zsh
kubectl apply -f ./milk-services/deployments/monitoring/deployment-prometheus.yaml
```

### Deploy Grafana
```zsh
kubectl apply -f ./milk-services/deployments/monitoring/deployment-grafana.yaml
```

#### Deploy Grafana Dashboards
```zsh
kubectl apply -f ./milk-services/deployments/monitoring/configmap-grafana-dashboards.yaml
```

#### Port Forwarding Grafana
```zsh
kubectl port-forward -n bd-bd-stud-olmoe22 deployment/grafana 3000:3000
```

### Deploy Node Exporter
```zsh
kubectl apply -f ./milk-services/deployments/monitoring/deployment-node-exporter.yaml
```

### Send Test Requests to prod-line-sys-svc
```zsh
# Send 50 requests per second until 3,000 requests are reached (takes 60 seconds)
for i in $(seq 1 300000); do
  curl -X POST http://prod-line-sys-svc:8080/api/v1/smart-buffer-tanks/temperature-measurement \
    -H "Content-Type: application/json" \
    -d "{\"temperature\":2,\"timestamp\":\"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\"}" &
  if (( $i % 500 == 0 )); then sleep 1; fi
done
```
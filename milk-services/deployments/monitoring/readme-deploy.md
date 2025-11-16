### Deploy Promtheus
```zsh
kubectl apply -f ./milk-services/deployments/monitoring/deployment-prometheus.yaml
```

### Deploy Grafana
```zsh
kubectl apply -f ./milk-services/deployments/monitoring/deployment-grafana.yaml
```

#### Port Forwarding Grafana
```zsh
kubectl port-forward -n bd-bd-stud-olmoe22 deployment/grafana 3000:3000
```
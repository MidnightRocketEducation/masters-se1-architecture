### Deploying
#### Prod Line System Service - Deployment
```zsh
kubectl apply -f deployments/prod-line-sys/prod-line-sys-svc/deployment-prod-line-sys-svc.yaml
```

#### Prod Line System Service - Service
```zsh
kubectl apply -f deployments/prod-line-sys/prod-line-sys-svc/svc-prod-line-sys-svc.yaml
```

### Other useful commands
#### send payload to prod-line-sys-svc
```zsh
curl -X POST http://prod-line-sys-svc:8080/api/v1/smart-buffer-tanks/temperature-measurement \
  -H "Content-Type: application/json" \
  -d '{
    "temperature": 2,
    "timestamp": "2025-11-15T12:34:56Z"
  }'
```
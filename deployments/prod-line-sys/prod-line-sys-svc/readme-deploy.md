## Deploying

### Deploy Prod Line System Service

```zsh
kubectl apply -f deployments/prod-line-sys/prod-line-sys-svc/prod-line-sys-svc-deployment.yaml
```

### Deploy k8s Service

```zsh
kubectl apply -f deployments/prod-line-sys/prod-line-sys-svc/prod-line-sys-svc-service.yaml
```

## Send payload to prod-line-sys-svc

### Send payload once

```zsh
curl -X POST http://prod-line-sys-svc:8080/api/v1/smart-buffer-tanks/temperature-measurement \
  -H "Content-Type: application/json" \
  -d '{
    "temperature": 2,
    "timestamp": "2025-11-15T12:34:56Z"
  }'
```

### Send multiple payloads in a loop

```zsh
# Send 500 requests per second until 300000 requests are reached (takes 600 seconds)
for i in $(seq 1 300000); do
  curl -X POST http://prod-line-sys-svc:8080/api/v1/smart-buffer-tanks/temperature-measurement \
    -H "Content-Type: application/json" \
    -d "{\"temperature\":2,\"timestamp\":\"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\"}" &
  if (( $i % 500 == 0 )); then sleep 1; fi
done
```

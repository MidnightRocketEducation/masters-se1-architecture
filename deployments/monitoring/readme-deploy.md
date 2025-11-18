### 1. Deploy Prometheus

```zsh
kubectl apply -f ./deployments/monitoring/deployment-prometheus.yaml
```

### 2. Deploy Node Exporter

```zsh
kubectl apply -f ./deployments/monitoring/deployment-node-exporter.yaml
```

### 3. Deploy Grafana

```zsh
kubectl apply -f ./deployments/monitoring/deployment-grafana.yaml
```

#### 3.1 Deploy Grafana Dashboards

```zsh
kubectl apply -f ./deployments/monitoring/configmap-grafana-dashboards.yaml
```

#### 3.2 Port Forwarding Grafana

```zsh
kubectl port-forward -n bd-bd-stud-olmoe22 deployment/grafana 3000:3000
```

### 4. Deploy k6

```zsh
kubectl apply -f ./deployments/monitoring/deployment-k6.yaml
```

#### A4.1 Shell into k6 pod

```zsh
kubectl exec -it deploy/k6-client -- sh
```

#### A4.2 Create load test script file

```zsh
cat > test.js << 'EOF'
import http from 'k6/http';
        import { check, sleep } from 'k6';

        export const options = {
          scenarios: {
            high_concurrency: {
              executor: 'constant-vus',
              vus: 50000,                // 50,000 VUs per pod
              duration: '45m',           // 20 pods × 50,000 VUs = 1,000,000 total
            },
          },
          thresholds: {
            http_req_duration: ['p(95)<5000'],
            http_req_failed: ['rate<0.1'],
          },
          noConnectionReuse: true,
          discardResponseBodies: true,
        };

        const payloads = Array.from({ length: 1000 }, (_, i) =>
          JSON.stringify({
            temperature: (Math.random() * 10).toFixed(2),
            timestamp: new Date(Date.now() - i * 1000).toISOString()
          })
        );

        export default function() {
          const url = 'http://prod-line-sys-svc:8080/api/v1/smart-buffer-tanks/temperature-measurement';
          const randomPayload = payloads[Math.floor(Math.random() * payloads.length)];

          const params = {
            headers: {
              'Content-Type': 'application/json',
              'Connection': 'close'
            },
            timeout: '60s',
          };

          const res = http.post(url, randomPayload, params);

          check(res, {
            'status is 200': (r) => r.status === 200,
            'response time < 10s': (r) => r.timings.duration < 10000,
          });

          sleep(1);
        }
EOF
```

#### A4.3 Run k6 load test

```zsh
k6 run test.js
```

### Send Test Requests to prod-line-sys-svc

```zsh
# Send 500 requests per second until 300000 requests are reached (takes 600 seconds)
for i in $(seq 1 300000); do
  curl -X POST http://prod-line-sys-svc:8080/api/v1/smart-buffer-tanks/temperature-measurement \
    -H "Content-Type: application/json" \
    -d "{\"temperature\":2,\"timestamp\":\"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\"}" &
  if (( $i % 500 == 0 )); then sleep 1; fi
done
```

### Metrics Server

#### Download the Metrics Server components.yaml file

```zsh
curl -LO https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

#### Apply the Metrics Server components.yaml file

```zsh
kubectl apply -f ./deployments/monitoring/metrics-server-deployment.yaml
```

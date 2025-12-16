## Option A: k6 Stress test (k6 ressource, requires admin permissions)

### 1A. Install the k6 operator in your namespace

```zsh
kubectl k6 install operator -n bd-bd-stud-olmoe22
```

### 1B. Or if you need cluster-wide installation (requires cluster admin)

```zsh
kubectl apply -f https://github.com/grafana/k6-operator/releases/latest/download/k6-operator.yaml
```

### 2. Deploy Stress Test

```zsh
kubectl apply -f ./deployments/experiment/k6-stress-test-deployment.yaml
```

## Option B: k6 Stress test (k8s job, without admin permissions)

### 1. Deploy configmap with k6 test script

```zsh
kubectl apply -f ./deployments/experiment/k6-stress-test-configmap.yaml
```

### 2. Deploy kubernetes job to run k6 test

```zsh
kubectl apply -f ./deployments/experiment/k6-stress-test-job.yaml
```

### 3. Save logs of the job pod

```zsh
kubectl logs -n bd-bd-stud-olmoe22 k6-performance-test-7lhzc > k6-results.log
```

## Option C: k6 client for interactive load testing

### 1. Deploy k6 client pod

```zsh
kubectl apply -f ./deployments/monitoring/deployment-k6.yaml
```

### 2. Shell into k6 pod

```zsh
kubectl exec -it deploy/k6-client -- sh
```

### 3. Create load test script file

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

### 4. Run k6 load test

```zsh
k6 run test.js
```

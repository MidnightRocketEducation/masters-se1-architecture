## 1. Deploy Prometheus

```zsh
kubectl apply -f ./deployments/monitoring/prometheus-deployment.yaml
```

## 2. Deploy Node Exporter

```zsh
kubectl apply -f ./deployments/monitoring/node-exporter-deployment.yaml
```

## 3. Deploy Grafana

### 3.1 Deploy Grafana Dashboards

```zsh
kubectl apply -f ./deployments/monitoring/grafana-dashboards-configmap.yaml
```

### 3.2 Deploy Grafana

```zsh
kubectl apply -f ./deployments/monitoring/grafana-deployment.yaml
```

### 3.3 Expose Grafana

```zsh
kubectl apply -f ./deployments/monitoring/grafana-expose-service.yaml
```

#### Expose via NodePort

This exposes Grafana on something like `http://<NodeIP>:32690`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: grafana
  namespace: bd-bd-stud-olmoe22
  labels:
    app: grafana
spec:
  type: NodePort
  ports:
    - port: 3000
      targetPort: 3000
      protocol: TCP
      name: http
  selector:
    app: grafana
```

#### Expose via Ingress

However to make Grafana accessible on `http://leftover.tek.sdu.dk/grafana` an INGRESS resource is needed.

#### Install NGINX Ingress Controller (if not already installed - requires k8s admin permissions)

```zsh
curl -LO https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/cloud/deploy.yaml
```

Move and eventually rename downloaded file to fit repo structure.

Then apply the Ingress NGINX deployment:

```zsh
kubectl apply -f ./deployments/monitoring/ingress-nginx-deployment.yaml
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

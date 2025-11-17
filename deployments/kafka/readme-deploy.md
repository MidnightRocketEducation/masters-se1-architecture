### Interactive Kafka pod
```zsh
kubectl run kafka-client -it --rm --restart='Never' --image docker.io/bitnami/kafka:3.8.0-debian-12-r3  -- bash
```

### Kafka topics
#### Query existing topics
```zsh
kafka-topics.sh --bootstrap-server kafka:9092 --list
```

#### Watch messages from a topic
```zsh
¨¨
```

#### Send messages to a topic
```zsh
kafka-console-producer.sh --bootstrap-server kafka:9092 --topic <topic-name>
```


# Kafka Message Broker

This component provides Apache Kafka for real-time messaging in the Big Data application.

## Components

- **Zookeeper**: Coordination service for Kafka cluster management
- **Kafka Broker**: Message broker for publishing and subscribing to topics

## Architecture

- **Zookeeper**: Runs on port 2181, provides cluster coordination
- **Kafka Broker**: Runs on port 9092, handles message processing

## Deployment

```bash
kubectl apply -f zookeeper-deployment.yaml
kubectl apply -f zookeeper-service.yaml
kubectl apply -f kafka-deployment.yaml
kubectl apply -f kafka-service.yaml
```

## Topics

The following topics are used by the Spark Streaming application:
- `prediction-requests`: Input topic for prediction requests (Avro format)
- `prediction-responses`: Output topic for prediction responses (Avro format)

## Testing

Create topics manually:

```bash
# Get Kafka pod name
kubectl get pods

# Create topics
kubectl exec -it kafka-<pod-id> -- kafka-topics --create --topic prediction-requests --bootstrap-server localhost:9092
kubectl exec -it kafka-<pod-id> -- kafka-topics --create --topic prediction-responses --bootstrap-server localhost:9092

# List topics
kubectl exec -it kafka-<pod-id> -- kafka-topics --list --bootstrap-server localhost:9092
```

## Configuration

Default settings:
- Single broker setup (suitable for development)
- PLAINTEXT protocol (no authentication)
- Topic replication factor: 1
- Auto-create topics: enabled
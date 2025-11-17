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
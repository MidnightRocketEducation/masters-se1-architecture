package dk.sdu.asaat.prod_line_sys_svc.common.infrastructure;

import dk.sdu.asaat.prod_line_sys_svc.common.application.MessagePublisher;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

@Service
public class KafkaMessagePublisher implements MessagePublisher {
    private final KafkaTemplate<String, Object> kafkaTemplate;

    public KafkaMessagePublisher(KafkaTemplate<String, Object> kafkaTemplate) {
        this.kafkaTemplate = kafkaTemplate;
    }

    @Override
    public void publish(String topic, Object request) {
        kafkaTemplate.send(topic, request);
    }
}

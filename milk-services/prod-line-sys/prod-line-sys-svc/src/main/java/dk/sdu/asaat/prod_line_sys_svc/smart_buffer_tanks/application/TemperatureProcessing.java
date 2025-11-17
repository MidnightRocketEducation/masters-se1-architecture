package dk.sdu.asaat.prod_line_sys_svc.smart_buffer_tanks.application;

import dk.sdu.asaat.prod_line_sys_svc.common.application.MessagePublisher;
import dk.sdu.asaat.prod_line_sys_svc.smart_buffer_tanks.core.TemperatureRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class TemperatureProcessing {
    private final MessagePublisher publisher;

    @Value("${kafka.topic.smart-buffer-tanks}")
    private String topic;

    public TemperatureProcessing(MessagePublisher publisher) {
        this.publisher = publisher;
    }

    public void processTemperature(TemperatureRequest temperature) {
        publisher.publish(topic, temperature);
    }
}

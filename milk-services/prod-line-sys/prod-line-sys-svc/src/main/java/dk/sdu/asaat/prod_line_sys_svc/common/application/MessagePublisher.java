package dk.sdu.asaat.prod_line_sys_svc.common.application;

public interface MessagePublisher {
    void publish(String topic, Object message);
}

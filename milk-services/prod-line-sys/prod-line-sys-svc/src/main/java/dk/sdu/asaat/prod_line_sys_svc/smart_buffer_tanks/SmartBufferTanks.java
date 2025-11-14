package dk.sdu.asaat.prod_line_sys_svc.smart_buffer_tanks;

import dk.sdu.asaat.prod_line_sys_svc.smart_buffer_tanks.dto.TemperatureRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/smart-buffer-tanks")
public class SmartBufferTanks {
    @PostMapping("/temperature-measurement")
    public ResponseEntity<Void> createTemperatureMeasurement(@RequestBody TemperatureRequest temperatureRequest) {
        // TODO: implement processing (publish to Kafka, validate, transformation etc.)
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }
}
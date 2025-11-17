package dk.sdu.asaat.prod_line_sys_svc.smart_buffer_tanks.pesentation;

import dk.sdu.asaat.prod_line_sys_svc.smart_buffer_tanks.application.TemperatureProcessing;
import dk.sdu.asaat.prod_line_sys_svc.smart_buffer_tanks.core.TemperatureRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/smart-buffer-tanks")
public class SmartBufferTanksController {
    private TemperatureProcessing temperatureProcessing;

    public SmartBufferTanksController(TemperatureProcessing temperatureProcessing) {
        this.temperatureProcessing = temperatureProcessing;
    }

    @PostMapping("/temperature-measurement")
    public ResponseEntity<Void> createTemperatureMeasurement(@RequestBody TemperatureRequest temperatureRequest) {
        temperatureProcessing.processTemperature(temperatureRequest);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }
}
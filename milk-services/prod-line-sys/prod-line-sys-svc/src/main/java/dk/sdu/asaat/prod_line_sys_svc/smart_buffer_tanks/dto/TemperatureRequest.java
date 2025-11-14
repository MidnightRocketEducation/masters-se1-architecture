package dk.sdu.asaat.prod_line_sys_svc.smart_buffer_tanks.dto;

import java.time.Instant;

public record TemperatureRequest(
        int temperature,
        Instant timestamp
) {}

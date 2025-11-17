package dk.sdu.asaat.prod_line_sys_svc.smart_buffer_tanks.core;

import java.time.Instant;

public record TemperatureRequest(
        double temperature,
        Instant timestamp
) {}

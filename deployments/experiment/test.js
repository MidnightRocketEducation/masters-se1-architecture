import http from "k6/http";
import { check } from "k6";
import { textSummary } from "https://jslib.k6.io/k6-summary/0.0.1/index.js";

const stages = Array.from({ length: 10 }, (_, i) => (i + 1) * 1000);

export const options = {
  scenarios: Object.fromEntries(
    stages.map((rps, idx) => [
      `stage_${rps}_rps`,
      {
        executor: "constant-arrival-rate",
        rate: rps,
        timeUnit: "1s",
        duration: "30s",
        preAllocatedVUs: Math.ceil(rps / 5),
        maxVUs: Math.ceil(rps / 2),
        ...(idx > 0 ? { startTime: `${10 * idx}s` } : {}),
        tags: { stage: `${rps}_rps` },
      },
    ])
  ),
  thresholds: Object.fromEntries(
    stages.map((rps) => [
      `http_req_duration{stage:${rps}_rps}`,
      ["p(95)<100", "p(95)<50"],
    ])
  ),
};

const payloads = Array.from({ length: 10 }, (_, i) =>
  JSON.stringify({
    temperature: (Math.random() * 10).toFixed(2),
    timestamp: new Date(Date.now() - i * 1000).toISOString(),
  })
);

export default function () {
  const url =
    "http://prod-line-sys-svc:8080/api/v1/smart-buffer-tanks/temperature-measurement";
  const randomPayload = payloads[Math.floor(Math.random() * payloads.length)];

  const params = {
    headers: {
      "Content-Type": "application/json",
    },
    timeout: "2s",
  };

  const res = http.post(url, randomPayload, params);

  check(res, {
    "status is 201": (r) => r.status === 201,
    "response time ≤ 100ms": (r) => r.timings.duration <= 100,
    "response time ≤ 50ms": (r) => r.timings.duration <= 50, // Added 50ms check
  });
}

export function handleSummary(data) {
  const stagesList = Array.from(
    { length: 10 },
    (_, i) => `${(i + 1) * 1000}_rps`
  );
  const stageResults = {};
  let threshold50msExceededAt = null;
  let threshold100msExceededAt = null;

  stagesList.forEach((stage) => {
    const stageData = data.metrics[`http_req_duration{stage:${stage}}`];

    if (stageData && stageData.values) {
      const p95 = stageData.values["p(95)"];
      const p99 = stageData.values["p(99)"];
      const avg = stageData.values.avg;
      const meets50msRequirement = p95 <= 50;
      const meets100msRequirement = p95 <= 100;

      stageResults[stage] = {
        target_rps: parseInt(stage.split("_")[0]),
        p95_latency: p95,
        p99_latency: p99,
        avg_latency: avg,
        total_requests: stageData.values.count,
        meets_50ms_requirement: meets50msRequirement,
        meets_100ms_requirement: meets100msRequirement,
      };

      // Track when 50ms threshold is first exceeded
      if (!meets50msRequirement && !threshold50msExceededAt) {
        threshold50msExceededAt = {
          stage: stage,
          rps: parseInt(stage.split("_")[0]),
          actual_p95: p95,
        };
      }

      // Track when 100ms threshold is first exceeded
      if (!meets100msRequirement && !threshold100msExceededAt) {
        threshold100msExceededAt = {
          stage: stage,
          rps: parseInt(stage.split("_")[0]),
          actual_p95: p95,
        };
      }
    }
  });

  // Calculate maximum compliant RPS for both thresholds
  const getMaxCompliantRPS = (thresholdExceededAt) => {
    if (!thresholdExceededAt) {
      return stages[stages.length - 1];
    }
    const exceededIndex = stagesList.indexOf(thresholdExceededAt.stage);
    return exceededIndex > 0
      ? parseInt(stagesList[exceededIndex - 1].split("_")[0])
      : 0;
  };

  const analysis = {
    stages: stageResults,
    threshold_analysis: {
      // 50ms Analysis (Excellent Performance)
      meets_50ms_standard: !threshold50msExceededAt,
      threshold_50ms_exceeded_at: threshold50msExceededAt,
      maximum_50ms_compliant_rps: getMaxCompliantRPS(threshold50msExceededAt),

      // 100ms Analysis (Industrial Standard)
      meets_industrial_standard: !threshold100msExceededAt,
      threshold_100ms_exceeded_at: threshold100msExceededAt,
      maximum_industrial_compliant_rps: getMaxCompliantRPS(
        threshold100msExceededAt
      ),

      // Performance Classification
      performance_classification: !threshold50msExceededAt
        ? "Excellent"
        : !threshold100msExceededAt
        ? "Good"
        : "Marginal",
    },
    summary: {
      total_requests: data.metrics.http_reqs.values.count,
      total_errors: data.metrics.http_req_failed.values.count,
      error_rate: data.metrics.http_req_failed.values.rate,
      overall_p95_latency: data.metrics.http_req_duration.values["p(95)"],
    },
  };

  console.log("=== DUAL-THRESHOLD PERFORMANCE ANALYSIS ===");
  console.log(JSON.stringify(analysis, null, 2));

  // Print summary
  console.log("\n=== PERFORMANCE SUMMARY ===");
  console.log(
    `Performance Classification: ${analysis.threshold_analysis.performance_classification}`
  );
  console.log(
    `50ms Threshold: ${
      analysis.threshold_analysis.meets_50ms_standard
        ? `Maintained up to ${analysis.threshold_analysis.maximum_50ms_compliant_rps} RPS`
        : `Exceeded at ${analysis.threshold_analysis.threshold_50ms_exceeded_at.rps} RPS`
    }`
  );
  console.log(
    `100ms Industrial Standard: ${
      analysis.threshold_analysis.meets_industrial_standard
        ? `Maintained up to ${analysis.threshold_analysis.maximum_industrial_compliant_rps} RPS`
        : `Exceeded at ${analysis.threshold_analysis.threshold_100ms_exceeded_at.rps} RPS`
    }`
  );

  return {
    stdout: textSummary(data, { indent: " ", enableColors: false }),
  };
}

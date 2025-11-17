// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser;
import Foundation;

@main
struct simple_temperature_sensor: AsyncParsableCommand {
	static let configuration: CommandConfiguration = .init(
		commandName: Bundle.main.executableURL?.lastPathComponent,
		abstract: "Simple temeprature sensor deamon",
	);

	@Option(
		help: .init(
			"Update interval in seconds. Defaults to the value of env \(ENV.INTERVAL.name) if set, otherwise 60 seconds.",
			valueName: "seconds"
		)
	) var interval: Int = ProcessInfo.processInfo.environment[ENV.INTERVAL.name].flatMap(Int.init) ?? 60;

	@Option(
		help: .init(
			"Temperature in degrees Celsius. Defaults to the value of env \(ENV.TEMPERATURE.name) if set, otherwise 4.1 °C."
		)
	) var temperature: Double = ProcessInfo.processInfo.environment[ENV.INTERVAL.name].flatMap(Double.init) ?? 4.1;

	@Option(
		name: [.customLong("push-url"), .long],
		help: .init(
			"URL to POST temperature data to. Either set this or the \(ENV.PUSH_URL.name) environment variable.",
			valueName: "url"
		),
		transform: parseURL
	) var url: URL?;

	mutating func run() async throws {
		guard let url else {
			throw ValidationError("Either set the --push-url option or the \(ENV.PUSH_URL.name) environment variable.");
		}

		stderr("Starting...");
		stderr("Configured url: \(self.url?.absoluteString ?? "n/a")")

		let daemon = TempDaemon(temperature: self.temperature, interval: .seconds(self.interval), url: url);

		await daemon.loop();
	}


	mutating func validate() throws {
		if self.url == nil {
			self.url = try ENV.PUSH_URL.value.map(parseURL);
		}
	}
}


func parseURL(_ str: String) throws -> URL {
	guard let url = URL(string: str) else {
		throw ValidationError("Not a valid URL");
	}
	return url;
}

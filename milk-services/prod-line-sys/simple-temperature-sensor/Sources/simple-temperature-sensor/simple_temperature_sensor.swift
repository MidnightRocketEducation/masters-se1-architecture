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
		name: [.customLong("push-url"), .long],
		help: .init(
			"URL to POST temperature data to. Either set this or the \(ENV.PUSH_URL.name) environment variable.",
			valueName: "url"
		),
		transform: parseURL
	) var url: URL?;

	mutating func run() async throws {
		let task = Task {
			while true {
				let t = TemperatureReading(temperature: 22.1);
				print("Temperature: \(t.asJSON())");
				try await Task.sleep(for: .seconds(60));
			}
		}

		while true {
			let input = readLine(strippingNewline: true) ?? "";
			if input == "exit" {
				print("Exiting...");
				task.cancel();
				throw ExitCode(0);
			}
		}
	}


	mutating func validate() throws {
		guard let url = try self.url ?? ENV.PUSH_URL.value.map(parseURL) else {
			throw ValidationError("Either set the --push-url option or the \(ENV.PUSH_URL.name) environment variable.");
		}
		self.url = url;
	}
}


func parseURL(_ str: String) throws -> URL {
	guard let url = URL(string: str) else {
		throw ValidationError("Not a valid URL");
	}
	return url;
}

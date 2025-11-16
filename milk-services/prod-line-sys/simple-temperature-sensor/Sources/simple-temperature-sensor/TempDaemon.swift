//
//
//  TempDaemon.swift
//  simple-temperature-sensor
//
//  Created by MidnightRocket on 16/11/2025.
//  
//  
import Foundation;

actor TempDaemon {
	private var task: Task<Void, Never>?;

	let temperature: Double;
	let interval: Duration;
	let url: URL;

	init(temperature: Double, interval: Duration, url: URL) {
		self.interval = interval;
		self.temperature = temperature;
		self.url = url;
	}

	func loop() async {
		self.task = Task {
			while true {
				print("Temperature: \(self.temperature)°C")
				await self.postTemperature();
				try? await Task.sleep(for: self.interval)
			}
		}

		await self.task?.value;
	}

	private func postTemperature() async {
		let tempReading = TemperatureReading(self.temperature);
		await WebClient.post(url: self.url, body: tempReading.asJSONData());
	}
}

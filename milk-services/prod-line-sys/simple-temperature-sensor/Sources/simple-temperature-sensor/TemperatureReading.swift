//
//
//  Temperature.swift
//  simple-temperature-sensor
//
//  Created by MidnightRocket on 15/11/2025.
//  
//  
import Foundation;

struct TemperatureReading: Codable {
	let timestamp: Date;
	let temperature: Double;

	init(timestamp: Date, temperature: Double) {
		self.timestamp = timestamp
		self.temperature = temperature
	}

	init (_ temperature: Double) {
		self.timestamp = Date();
		self.temperature = temperature;
	}

	func asJSONData() -> Data {
		let encoder = JSONEncoder();
		encoder.dateEncodingStrategy = .iso8601;
		return (try? encoder.encode(self)) ?? Data("{}".utf8);
	}
}

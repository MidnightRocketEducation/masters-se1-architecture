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

	init (temperature: Double) {
		self.timestamp = Date();
		self.temperature = temperature;
	}

	func asJSON() -> String {
		let encoder = JSONEncoder();
		encoder.dateEncodingStrategy = .iso8601;
		if let data = try? encoder.encode(self),
		   let jsonString = String(data: data, encoding: .utf8) {
			return jsonString;
		}
		return "{}";
	}
}

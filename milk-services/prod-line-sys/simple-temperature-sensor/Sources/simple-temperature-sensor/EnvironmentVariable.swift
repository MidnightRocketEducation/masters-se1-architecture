//
//
//  EnvironmentVariable.swift
//  simple-temperature-sensor
//
//  Created by MidnightRocket on 16/11/2025.
//  
//  
import Foundation;

enum ENV {
	static let prefix = "ST_"; // ST for Simple Temp

	case PUSH_URL,
		 INTERVAL,
		TEMPERATURE;

	var value: String? {
		ProcessInfo.processInfo.environment[self.name];
	}

	var name: String {
		Self.prefix + String(describing: self);
	}
}

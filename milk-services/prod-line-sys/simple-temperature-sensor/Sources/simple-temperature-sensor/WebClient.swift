//
//
//  WebClient.swift
//  simple-temperature-sensor
//
//  Created by MidnightRocket on 15/11/2025.
//  
//  

import Foundation;
#if canImport(FoundationNetworking)
import FoundationNetworking;
#endif


struct WebClient {
	static private let session = URLSession.shared;

	static func run<T: Sendable>(url: URL, method: Method, body: Data? = nil, token: String) async -> T?  where T: Codable {
		var request = URLRequest(url: url);
		request.httpMethod = method.rawValue;
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization");
		request.setValue("application/json", forHTTPHeaderField: "accept");
		request.httpBody = body;
		do {
			let (data, _) = try await Self.session.data(for: request)
			let decoder = JSONDecoder();
			let simpleDateFormatter = DateFormatter();
			simpleDateFormatter.dateFormat = "yyyy-MM-dd";
			decoder.dateDecodingStrategy = .formatted(simpleDateFormatter);
			return try decoder.decode(T.self, from: data);
		} catch(let e) {
			print(e);
			return nil;
		}
	}
}


extension WebClient {
	enum Method: String {
		case get = "GET";
		case post = "POST";
		case put = "PUT";
		case delete = "DELETE";
	}
}

// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser

@main
struct simple_temperature_sensor: ParsableCommand {
    mutating func run() throws {
        print("Hello, world!")
    }
}

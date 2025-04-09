// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
// Package.swift
import PackageDescription

let package = Package(
    name: "AppCloser",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "AppCloser",
            dependencies: []),
    ]
)

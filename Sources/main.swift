//
//  main.swift
//  Perfect Session PostgreSQL Demo
//
//  Created by Jonathan Guthrie on 2017-01-05.
//	Copyright (C) 2017 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 20176 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//



import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectSession
import PerfectSessionPostgreSQL
import PerfectLogger

//let timer = Each(1).seconds
//
//timer.perform {
//	// Do your operations
//	// This closure has to return a NextStep value
//	// Return .continue if you want to leave the timer active, otherwise
//	// return .stop to invalidate it
//
//	print("yo")
//	LogFile.debug("yo")
//	return .continue
//}


let server = HTTPServer()

SessionConfig.name = "TestingPostgresDrivers"
SessionConfig.idle = 60

// Optional
SessionConfig.cookieDomain = "localhost"
SessionConfig.IPAddressLock = true
SessionConfig.userAgentLock = true
SessionConfig.CSRF.checkState = true

SessionConfig.CORS.enabled = true
SessionConfig.CORS.acceptableHostnames.append("http://www.test-cors.org")
//SessionConfig.CORS.acceptableHostnames.append("*.test-cors.org")
SessionConfig.CORS.maxAge = 60

PostgresSessionConnector.host = "localhost"
PostgresSessionConnector.username = "perfect"
PostgresSessionConnector.password = "perfect"
PostgresSessionConnector.database = "perfect_testing"
PostgresSessionConnector.table = "sessions"

let sessionDriver = SessionPostgresDriver()

server.setRequestFilters([sessionDriver.requestFilter])
server.setResponseFilters([sessionDriver.responseFilter])

server.addRoutes(makeWebDemoRoutes())
server.serverPort = 8181

do {
	// Launch the HTTP server.
	try server.start()
} catch PerfectError.networkError(let err, let msg) {
	print("Network error thrown: \(err) \(msg)")
}

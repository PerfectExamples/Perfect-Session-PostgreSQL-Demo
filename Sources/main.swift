

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectSession
import PerfectSessionPostgreSQL

let server = HTTPServer()

SessionConfig.name = "TestingPostgresDrivers"
SessionConfig.idle = 10

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

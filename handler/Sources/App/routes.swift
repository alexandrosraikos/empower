import Fluent
import Vapor
import Metrics
import Prometheus

func routes(_ app: Application) throws {
    
    // ---- Initialize Prometheus exporting &  metrics.
    let prometheusClient = PrometheusClient()
    MetricsSystem.bootstrap(prometheusClient)
    let metricsCollector = try MetricsSystem.prometheus()
    
    // -- METRIC: Response time for each database request.
    var dbRequestTime = Date()
    let dbResponseTime = prometheusClient.createGauge(forType: Int.self, named: "database_response_time")

    // -- METRIC: Requests routed between metric scrapes.
    let numberOfRequests = prometheusClient.createGauge(forType: Int.self, named: "total_requests")
    
    // -- METRIC: Active sessions.
    // ERROR: ADDS EVERY REQUEST.
    let activeUserCount = prometheusClient.createGauge(forType: Int.self, named: "recently_active_users")
    
    // Route for the front-end web application.
    app.get("quotes") { req -> EventLoopFuture<Quote> in
        numberOfRequests.inc()
        dbRequestTime = Date()
        
        // Capture session.
        if (req.session.data["uuid"] == nil) {
            req.session.data["uuid"] = req.parameters.get("uuid")!
        }
        
        // Count RTT for Mongo request.
        let quote = Quote
            .query(on: app.db)
            .offset(Int.random(in: 0..<quoteCount))
            .first()
            ??
            Quote(quote: "An error has occured", citation: "Your Swift server")
        
        // Add last request's database response time.
        quote.whenSuccess {q in
            dbResponseTime.set(Int(Date().timeIntervalSince(dbRequestTime)*1000.0))
        }
        
        // Retrieve random quote and return
        return quote
    }
    
    // Route for the Netdata Prometheus collector.
    app.get("metrics") { req -> EventLoopFuture<String> in
        activeUserCount.set(app.sessions.memory.storage.sessions.count)
        let metricResponse = req.eventLoop.makePromise(of: String.self)
        metricsCollector.collect(into: metricResponse)
        return metricResponse.futureResult
    }
}

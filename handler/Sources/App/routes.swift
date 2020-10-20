import Fluent
import Vapor

func routes(_ app: Application) throws {
    var sessions = Set<String>()
    var dbRequestTime: Date?
    var dbResponseTime: TimeInterval?
    
    app.get("quotes") { req -> EventLoopFuture<Quote> in
        dbRequestTime = Date()
        // Retrieve user session and add to active ones.
        let uuid = req.query[String.self, at: "uuid"]!
        sessions.insert(uuid)
        // Count RTT for Mongo request.
        let quote = Quote
            .query(on: app.db)
            .offset(Int.random(in: 0..<quoteCount))
            .first()
            ??
            Quote(quote: "An error has occured", citation: "Your Swift server")
        quote.whenSuccess {q in
            dbResponseTime = Date().timeIntervalSince(dbRequestTime!)*1000.0
            print("The response time is", Int(dbResponseTime!),"ms.")
        }
        // TODO: Expose NetData API.
        // Retrieve random quote and return
        return quote
    }
    
    app.post("metrics") { req -> Int in
        return Int(dbResponseTime!)
    }
}

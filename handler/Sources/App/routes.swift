import Fluent
import Vapor

func routes(_ app: Application) throws {
    var sessions = Set<String>()
    
    app.get("quotes") { req -> EventLoopFuture<Quote> in
        // Retrieve user session and add to active ones.
        let uuid = req.query[String.self, at: "uuid"]!
        sessions.insert(uuid)
        
        // Retrieve random quote and return
        return Quote
            .query(on: app.db)
            .offset(Int.random(in: 0..<quoteCount))
            .first()
            ??
            Quote(quote: "An error has occured", citation: "Your Swift server")
    }
}

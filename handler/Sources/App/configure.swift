import Fluent
import FluentMongoDriver
import Vapor

var quoteCount: Int = 0

// configures your application
public func configure(_ app: Application) throws {
    
    // ---- Connect to MongoDB
    
    print("Connecting to MongoDB host "+(Environment.get("DATABASE_URL") ?? "NOT!")+"...")
    try app.databases.use(.mongo(
        connectionString: "mongodb://"+(Environment.get("DATABASE_URL") ?? "localhost")+":27017/empower"
    ), as: .mongo)
    quoteCount = try! Quote.query(on: app.db).count().wait()
    print("[ NOTICE ] There are \(quoteCount) quotes in the database.")
    
    // ---- Initialization
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    app.middleware.use(CORSMiddleware(configuration: corsConfiguration))
    
    // ---- Session persistence.
    app.middleware.use(app.sessions.middleware)
    app.sessions.configuration.cookieFactory = { sessionID in
        .init(string: sessionID.string, isSecure: true)
    }
    app.sessions.use(.memory)
    
    
    // register routes
    try routes(app)
}

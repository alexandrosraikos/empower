import Fluent
import FluentMongoDriver
import Vapor

var quoteCount: Int = 0

// configures your application
public func configure(_ app: Application) throws {
    print("Connecting to MongoDB host "+(Environment.get("DATABASE_URL") ?? "NOT!")+"...")
    // Connect to MongoDB
    try app.databases.use(.mongo(
        connectionString: "mongodb://"+(Environment.get("DATABASE_URL") ?? "localhost")+":27017/empower"
    ), as: .mongo)
    quoteCount = try! Quote.query(on: app.db).count().wait()
    print("[ NOTICE ] There are \(quoteCount) quotes in the database.")

    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    app.middleware.use(CORSMiddleware(configuration: corsConfiguration))

    // register routes
    try routes(app)
}

import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    let databaseName: String

    if (app.environment == .testing) {
        databaseName = "vapor_test"
    } else {
        databaseName = Environment.get("DATABASE_NAME") ?? "vapor_database"
    }

    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: databaseName
    ), as: .psql)

    app.migrations.add(ProductCategory.Create())
    app.migrations.add(Product.Create())
    app.migrations.add(ColorVariant.Create())
    app.migrations.add(Order.Create())
    app.migrations.add(OrderItem.Create())

    app.migrations.add(Order.AddEmail())
    app.migrations.add(ColorVariant.FixUniqueConstraint())

    if (app.environment != .testing) {
        app.migrations.add(Seed.Tops())
        app.migrations.add(Seed.Bottoms())
        app.migrations.add(Seed.Dresses())
        app.migrations.add(Seed.Footwear())
    }

    try app.autoMigrate().wait()
    
    // register routes
    try routes(app)
}

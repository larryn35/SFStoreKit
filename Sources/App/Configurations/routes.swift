import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: ProductCategoryController())
    try app.register(collection: ProductController())
    try app.register(collection: ColorVariantController())
    try app.register(collection: OrderController())
    try app.register(collection: OrderItemController())
}

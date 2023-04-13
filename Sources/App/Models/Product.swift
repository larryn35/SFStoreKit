//
//  Product.swift
//  
//
//  Created by Larry Nguyen on 4/4/23.
//

import Fluent
import Vapor

final class Product: Model, Content {
    static var schema: String = "products"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: .Product.categoryID)
    var category: ProductCategory

    @Field(key: .name)
    var name: String

    @Field(key: .Product.description)
    var description: String

    @Field(key: .Product.price)
    var price: Int

    @Field(key: .Product.sizes)
    var sizes: [String]

    @Children(for: \.$product)
    var variants: [ColorVariant]

    @Timestamp(key: .createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: .updatedAt, on: .update)
    var updatedAt: Date?

    init() {}

    init(id: UUID? = nil, category: ProductCategory.IDValue, name: String, description: String, price: Int, sizes: [String], createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.$category.id = category
        self.name = name
        self.description = description
        self.price = price
        self.sizes = sizes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    init(data: CreateData) {
        self.name = data.name
        self.description = data.description
        self.price = data.price
        self.sizes = data.sizes
    }
}

// Domain Transfer Objects (DTO)
extension Product {

    // GET
    struct ResponseData: Content, Decodable {
        let id: UUID?
        let category: String
        let name: String
        let description: String
        let price: Int
        let discount: Int
        let sizes: [String]
        let variants: [ColorVariant]
        let updatedAt: Date

        init(product: Product) {
            let discount = (Double(product.price) * Double(product.category.percentDiscount ?? 0))/100

            self.id = product.id
            self.category = product.category.name
            self.name = product.name
            self.description = product.description
            self.price = product.price
            self.discount = Int(discount)
            self.sizes = product.sizes
            self.variants = product.variants
            self.updatedAt = product.updatedAt ?? Date()
        }
    }

    // PATCH
    struct PatchData: Content, Decodable {
        var category: String?
        var name: String?
        var description: String?
        var price: Int?
        var sizes: [String]?
    }

    // POST
    struct CreateData: Content {
        let categoryName: String
        let name: String
        let description: String
        let price: Int
        let sizes: [String]
    }
}


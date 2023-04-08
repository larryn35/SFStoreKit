//
//  ProductCategory.swift
//  
//
//  Created by Larry Nguyen on 4/4/23.
//

import Fluent
import Vapor

final class ProductCategory: Model, Content {
    static let schema: String = "product_categories"

    @ID(key: .id)
    var id: UUID?

    @Field(key: .name)
    var name: String

    @Children(for: \.$category)
    var products: [Product]

    @Field(key: .ProductCategory.percentDiscount)
    var percentDiscount: Int?

    @Timestamp(key: .createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: .updatedAt, on: .update)
    var updatedAt: Date?

    init() {}

    init(id: UUID? = nil, name: String, percentDiscount: Int?, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.name = name
        self.percentDiscount = percentDiscount
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// Domain Transfer Objects (DTO)
extension ProductCategory {

    // PATCH
    struct PatchData: Content, Decodable {
        var name: String?
        var percentDiscount: Int?
    }
}

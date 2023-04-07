//
//  ColorVariant.swift
//  
//
//  Created by Larry Nguyen on 4/4/23.
//

import Fluent
import Vapor

final class ColorVariant: Model, Content {
    static let schema: String = "colorVariants"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: .ColorVariant.productID)
    var product: Product

    @Field(key: .ColorVariant.color)
    var color: String

    @Field(key: .ColorVariant.hex)
    var hex: String

    @Field(key: .ColorVariant.image)
    var image: String

    @Timestamp(key: .createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: .updatedAt, on: .update)
    var updatedAt: Date?

    init() {}

    init(id: UUID? = nil, product: Product.IDValue, color: String, hex: String, image: String, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.$product.id = product
        self.color = color
        self.hex = hex
        self.image = image
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    init(data: CreateData) {
        self.$product.id = data.productID
        self.color = data.color
        self.hex = data.hex
        self.image = data.image
    }
}

// Domain Transfer Objects (DTO)
extension ColorVariant {

    // POST
    struct CreateData: Content {
        let productID: UUID
        let color: String
        let hex: String
        let image: String
    }

    // PATCH
    struct PatchData: Content {
        var color: String?
        var hex: String?
        var image: String?
    }
}

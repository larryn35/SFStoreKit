//
//  OrderItem.swift
//  
//
//  Created by Larry Nguyen on 4/4/23.
//

import Fluent
import Vapor

final class OrderItem: Model, Content {
    static let schema: String = "orderItems"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: .OrderItem.orderID)
    var order: Order

    @Field(key: .name)
    var name: String

    @Field(key: .OrderItem.image)
    var image: String

    @Field(key: .OrderItem.color)
    var color: String

    @Field(key: .OrderItem.size)
    var size: String

    @Field(key: .OrderItem.price)
    var price: Int

    @Field(key: .OrderItem.discount)
    var discount: Int

    @Field(key: .OrderItem.quantity)
    var quantity: Int

    @Timestamp(key: .createdAt, on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, order: Order.IDValue, name: String, image: String, color: String, size: String, price: Int, discount: Int, quantity: Int, createdAt: Date? = nil) {
        self.id = id
        self.$order.id = order
        self.name = name
        self.image = image
        self.color = color
        self.size = size
        self.price = price
        self.discount = discount
        self.quantity = quantity
        self.createdAt = createdAt
    }

    init(data: CreateData) {
        self.$order.id = data.orderID
        self.name = data.name
        self.image = data.image
        self.color = data.color
        self.size = data.size
        self.price = data.price
        self.discount = data.discount
        self.quantity = data.quantity
    }
}

// Domain Transfer Objects (DTO)
extension OrderItem {

    // POST
    struct CreateData: Content {
        let orderID: UUID
        let name: String
        let image: String
        let color: String
        let size: String
        let price: Int
        let discount: Int
        let quantity: Int
    }
}

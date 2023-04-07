//
//  Order.swift
//  
//
//  Created by Larry Nguyen on 4/4/23.
//

import Fluent
import Vapor

final class Order: Model, Content {
    static let schema: String = "orders"

    @ID(key: .id)
    var id: UUID?

    @Children(for: \.$order)
    var items: [OrderItem]

    @Field(key: .Order.customerName)
    var customerName: String

    @Field(key: .Order.email)
    var email: String

    @Field(key: .Order.address)
    var address: String

    @Field(key: .Order.city)
    var city: String

    @Field(key: .Order.state)
    var state: String

    @Field(key: .Order.zip)
    var zip: String

    @Field(key: .Order.totalPrice)
    var totalPrice: Int

    @Field(key: .Order.discounts)
    var discounts: Int?

    @Timestamp(key: .createdAt, on: .create)
    var createdAt: Date?

    init() {}

    init(id: UUID? = nil, customerName: String, email: String, address: String, city: String, state: String, zip: String, totalPrice: Int, discounts: Int? = nil, createdAt: Date? = nil) {
        self.id = id
        self.customerName = customerName
        self.email = email
        self.address = address
        self.city = city
        self.state = state
        self.zip = zip
        self.totalPrice = totalPrice
        self.discounts = discounts
        self.createdAt = createdAt
    }
}


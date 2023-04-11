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

    @Timestamp(key: .createdAt, on: .create)
    var createdAt: Date?

    init() {}

    init(id: UUID? = nil, customerName: String, email: String, address: String, city: String, state: String, zip: String, createdAt: Date? = nil) {
        self.id = id
        self.customerName = customerName
        self.email = email
        self.address = address
        self.city = city
        self.state = state
        self.zip = zip
        self.createdAt = createdAt
    }

    init(data: CreateData) {
        self.id = data.id
        self.customerName = data.customerName
        self.email = data.email
        self.address = data.address
        self.city = data.city
        self.state = data.state
        self.zip = data.zip
    }
}

// Domain Transfer Objects (DTO)
extension Order {

    // GET
    struct Summary: Content {
        let customerName: String
        let email: String
        let address: String
        let city: String
        let state: String
        let zip: String
        let items: [OrderItem]
        let total: Int
        let savings: Int

        init(order: Order) {
            self.customerName = order.customerName
            self.email = order.email
            self.address = order.address
            self.city = order.city
            self.state = order.state
            self.zip = order.zip
            self.items = order.items
            self.total = items.total
            self.savings = items.savings
        }
    }

    // POST
    struct CreateData: Content {
        var id: UUID?
        var customerName: String
        var email: String
        var address: String
        var city: String
        var state: String
        var zip: String
        var items: [OrderItem.CreateData]
    }
}

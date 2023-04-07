//
//  Models+Testing.swift
//  
//
//  Created by Larry Nguyen on 4/6/23.
//

@testable import App
import Fluent
import Foundation

// MARK: - Order
extension Order {
    static func createTimsOrder(save db: Database? = nil) async throws -> Order {
        let order = Order(customerName: "Tim Apple",
                          email: "tim@apple.com",
                          address: "1 Apple Park Way",
                          city: "Cupertino",
                          state: "CA",
                          zip: "95014",
                          totalPrice: 20000,
                          discounts: 0)

        if let db {
            try await order.save(on: db)
        }

        return order
    }

    static func createLeannesOrder(save db: Database? = nil) async throws -> Order {
        let order = Order(customerName: "Leanne Graham",
                          email: "Sincere@april.biz",
                          address: "556 Kulas Light",
                          city: "Gwenborough",
                          state: "NA",
                          zip: "92998",
                          totalPrice: 8000,
                          discounts: 400)

        if let db {
            try await order.save(on: db)
        }

        return order
    }
}

// MARK: - OrderItem
extension OrderItem {
    static func createShirtOrderItem(for orderID: UUID, save db: Database? = nil) async throws -> OrderItem {
        let orderItem = OrderItem(order: orderID,
                                  name: "T-shirt",
                                  image: "tshirt-6D89C7",
                                  color: "Cerulean Frost",
                                  size: "M",
                                  price: 800,
                                  discount: 200,
                                  quantity: 2)

        if let db {
            try await orderItem.save(on: db)
        }

        return orderItem
    }

    static func createShirtOrderItemData(for orderID: UUID) -> OrderItem.CreateData {
        return .init(orderID: orderID,
                     name: "T-shirt",
                     image: "tshirt-6D89C7",
                     color: "Cerulean Frost",
                     size: "M",
                     price: 800,
                     discount: 200,
                     quantity: 2)
    }

    static func createShoesOrderItem(for orderID: UUID, save db: Database? = nil) async throws -> OrderItem {
        let orderItem = OrderItem(order: orderID,
                                  name: "Shoes",
                                  image: "shoes-BF85C2",
                                  color: "East Side",
                                  size: "11",
                                  price: 9000,
                                  discount: 1000,
                                  quantity: 1)

        if let db {
            try await orderItem.save(on: db)
        }

        return orderItem
    }
}

// MARK: - Product
extension Product {
    static func createShirtProduct(categoryID: UUID, save db: Database? = nil) async throws -> Product {
        let shirt = Product(category: categoryID,
                            name: "T-shirt",
                            description: "Shirt description",
                            price: 800,
                            sizes: ["S", "M", "L"])

        if let db {
            try await shirt.save(on: db)
        }

        return shirt
    }

    static func createShirtData(category: String) -> Product.CreateData {
        return .init(categoryName: category,
                     name: "T-shirt",
                     description: "Shirt description",
                     price: 800,
                     sizes: ["S", "M", "L"])
    }

    static func createPantsProduct(categoryID: UUID, save db: Database? = nil) async throws -> Product {
        let pants = Product(category: categoryID,
                            name: "Pants",
                            description: "Pants description",
                            price: 2400,
                            sizes: ["M", "L"])

        if let db {
            try await pants.save(on: db)
        }

        return pants
    }

    static func createPantsData(category: String) -> Product.CreateData {
        return .init(categoryName: category,
                     name: "Pants",
                     description: "Pants description",
                     price: 2400,
                     sizes: ["M", "L"])
    }
}
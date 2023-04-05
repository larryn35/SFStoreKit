//
//  OrderItemController.swift
//  
//
//  Created by Larry Nguyen on 4/4/23.
//

import Vapor

struct OrderItemController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let orderItems = routes.grouped("order-items")
        orderItems.get(use: index)
        orderItems.get(":orderID", use: fetchItemsForOrder)
        orderItems.post(use: create)
        orderItems.delete("delete", ":itemID", use: delete)
    }

    // GET Request: /order-items route
    func index(req: Request) async throws -> [OrderItem] {
        try await OrderItem.query(on: req.db).all()
    }

    // GET Request: /order-items/:orderID route
    func fetchItemsForOrder(req: Request) async throws -> [OrderItem] {
        guard let order = try await Order.find(req.parameters.get("orderID"), on: req.db) else {
            throw Abort(.notFound)
        }

        let items = try await order.$items.get(on: req.db)
        return items
    }

    // POST Request: /order-items route
    func create(req: Request) async throws -> [OrderItem] {
        let data = try req.content.decode([OrderItem.CreateData].self)
        let items = data.map { OrderItem(data: $0) }

        try await items.create(on: req.db)
        return items
    }

    // DELETE Request: /order-items/delete/{itemID} route
    func delete(req: Request) async throws -> Response {
        guard let item = try await OrderItem.find(req.parameters.get("itemID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await item.delete(on: req.db)
        return req.redirect(to: "/order-items")
    }
}

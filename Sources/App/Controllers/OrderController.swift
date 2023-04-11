//
//  OrderController.swift
//  
//
//  Created by Larry Nguyen on 4/4/23.
//

import Vapor
import Fluent

struct OrderController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let orders = routes.grouped("orders")
        orders.get(use: index)
        orders.get(":orderID", use: fetchOrderSummary)
        orders.post(use: create)
        orders.delete("delete", ":orderID", use: delete)
    }

    // GET Request: /orders route
    func index(req: Request) async throws -> [Order] {
        let orders = try await Order.query(on: req.db)
            .with(\.$items)
            .all()

        return orders
    }

    // GET Request: /orders/:orderID route
    func fetchOrderSummary(req: Request) async throws -> Order.Summary {
        guard
            let idString = req.parameters.get("orderID"),
            let uuid = UUID(uuidString: idString),
            let order = try await Order.query(on: req.db)
                .filter(\.$id == uuid)
                .with(\.$items)
                .all()
                .first
        else {
            throw Abort(.notFound)
        }

        return Order.Summary(order: order)
    }

    // POST Request: /orders route
    func create(req: Request) async throws -> Order.Summary {
        let orderData = try req.content.decode(Order.CreateData.self)
        let order = Order(data: orderData)
        try await order.save(on: req.db)

        let items = orderData.items.map { OrderItem(data: $0) }
        try await items.create(on: req.db)

        guard
            let id = order.id,
            let order = try await Order.query(on: req.db)
            .filter(\.$id == id)
            .with(\.$items)
            .all()
            .first
        else {
            throw Abort(.notFound)
        }

        return Order.Summary(order: order)
    }

    // DELETE Request: /orders/delete/:orderID
    func delete(req: Request) async throws -> Response {
        guard let order = try await Order.find(req.parameters.get("orderID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await order.delete(on: req.db)
        return req.redirect(to: "/orders")
    }
}

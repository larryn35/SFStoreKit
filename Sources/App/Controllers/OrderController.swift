//
//  OrderController.swift
//  
//
//  Created by Larry Nguyen on 4/4/23.
//

import Vapor

struct OrderController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let orders = routes.grouped("orders")
        orders.get(use: index)
        orders.post(use: create)
        orders.delete("delete", ":orderID", use: delete)
    }

    // GET Request: /orders route
    func index(req: Request) async throws -> [Order] {
        try await Order.query(on: req.db).with(\.$items).all()
    }

    // POST Request: /orders route
    func create(req: Request) async throws -> Order {
        let order = try req.content.decode(Order.self)
        try await order.save(on: req.db)
        return order
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

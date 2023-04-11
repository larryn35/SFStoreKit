//
//  OrderTests.swift
//  
//
//  Created by Larry Nguyen on 4/6/23.
//

@testable import App
import XCTVapor

final class OrderTests: XCTestCase {
    var app: Application!
    private let path = "/orders"

    override func setUpWithError() throws {
        app = try Application.testable()
     }

    override func tearDownWithError() throws {
        app.shutdown()
     }

    func testOrdersCanBeRetrievedFromAPI() async throws {
        let timsOrder = try await Order.createTimsOrder(save: app.db)

        try app.test(.GET, path, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)

            let orders = try response.content.decode([Order].self)

            XCTAssertEqual(orders.count, 1)
            XCTAssertEqual(orders[0].customerName, timsOrder.customerName)
            XCTAssertEqual(orders[0].address, timsOrder.address)
            XCTAssertEqual(orders[0].email, timsOrder.email)
            XCTAssertEqual(orders[0].city, timsOrder.city)
            XCTAssertEqual(orders[0].state, timsOrder.state)
            XCTAssertEqual(orders[0].zip, timsOrder.zip)
        })
    }

    func testOrderSummaryCanBeRetrievedFromAPI() async throws {
        let timsOrder = try await Order.createTimsOrder(save: app.db)
        let orderID = try XCTUnwrap(timsOrder.id)

        let shirtOrderItem = try await OrderItem.createShirtOrderItem(for: orderID, save: app.db)
        let shoesOrderItem = try await OrderItem.createShoesOrderItem(for: orderID, save: app.db)

        let expectedTotal = [shirtOrderItem, shoesOrderItem].total
        let expectedSavings = [shirtOrderItem, shoesOrderItem].savings

        let orderPath = path + "/\(orderID)"

        try app.test(.GET, orderPath, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)

            let orderSummary = try response.content.decode(Order.Summary.self)

            XCTAssertEqual(orderSummary.customerName, timsOrder.customerName)
            XCTAssertEqual(orderSummary.address, timsOrder.address)
            XCTAssertEqual(orderSummary.email, timsOrder.email)
            XCTAssertEqual(orderSummary.city, timsOrder.city)
            XCTAssertEqual(orderSummary.state, timsOrder.state)
            XCTAssertEqual(orderSummary.zip, timsOrder.zip)

            XCTAssertEqual(orderSummary.items[0].name, shirtOrderItem.name)

            XCTAssertEqual(orderSummary.total, expectedTotal)
            XCTAssertEqual(orderSummary.savings, expectedSavings)
        })
    }

    func testOrderBeSavedWithAPI() async throws {
        let timsOrder = Order.createTimsOrderData()

        try app.test(.POST, path, beforeRequest: { request in
            try request.content.encode(timsOrder)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)

            let orderSummary = try response.content.decode(Order.Summary.self)

            XCTAssertEqual(orderSummary.customerName, timsOrder.customerName)
            XCTAssertEqual(orderSummary.address, timsOrder.address)
            XCTAssertEqual(orderSummary.email, timsOrder.email)
            XCTAssertEqual(orderSummary.city, timsOrder.city)
            XCTAssertEqual(orderSummary.state, timsOrder.state)
            XCTAssertEqual(orderSummary.zip, timsOrder.zip)
        })

        let orderID = try XCTUnwrap(timsOrder.id)
        let orderItemsPath = "order-items/\(orderID)"

        try app.test(.GET, orderItemsPath, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)

            let orderItems = try response.content.decode([OrderItem].self)

            XCTAssertEqual(orderItems.count, 1)
            XCTAssertEqual(orderItems[0].name, timsOrder.items[0].name)
            XCTAssertEqual(orderItems[0].image, timsOrder.items[0].image)
            XCTAssertEqual(orderItems[0].color, timsOrder.items[0].color)
            XCTAssertEqual(orderItems[0].size, timsOrder.items[0].size)
            XCTAssertEqual(orderItems[0].price, timsOrder.items[0].price)
            XCTAssertEqual(orderItems[0].discount, timsOrder.items[0].discount)
            XCTAssertEqual(orderItems[0].quantity, timsOrder.items[0].quantity)
        })
    }

    func testOrderCanBeDeletedWithAPI() async throws {
        let dummyOrder = try await Order.createLeannesOrder(save: app.db)
        let timsOrder = try await Order.createTimsOrder(save: app.db)

        let dummyOrderID = try XCTUnwrap(dummyOrder.id)
        let deletePath = path + "/delete/\(dummyOrderID)"

        // Expected - Redirect back to /orders
        try app.test(.DELETE, deletePath, afterResponse: { response in
            if let location = response.headers.last {
                XCTAssertEqual(location.value, path)
            } else {
                XCTFail("Failed to redirect")
            }
        })

        // Expected - Tim's order remains
        try app.test(.GET, path, afterResponse: { response in
            let orders = try response.content.decode([Order].self)

            XCTAssertEqual(orders.count, 1)
            XCTAssertEqual(orders[0].customerName, timsOrder.customerName)
            XCTAssertEqual(orders[0].address, timsOrder.address)
            XCTAssertEqual(orders[0].email, timsOrder.email)
            XCTAssertEqual(orders[0].city, timsOrder.city)
            XCTAssertEqual(orders[0].state, timsOrder.state)
            XCTAssertEqual(orders[0].zip, timsOrder.zip)
        })
    }
}

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

    func testOrderCanBeRetrievedFromAPI() async throws {
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
            XCTAssertEqual(orders[0].totalPrice, timsOrder.totalPrice)
        })
    }

    func testOrderCalculatesCorrectDiscount() async throws {
        let timsOrder = try await Order.createTimsOrder(save: app.db)
        let orderID = try XCTUnwrap(timsOrder.id)

        let shirtOrderItem = try await OrderItem.createShirtOrderItem(for: orderID, save: app.db)
        let shoesOrderItem = try await OrderItem.createShoesOrderItem(for: orderID, save: app.db)

        let expectedDiscount = shirtOrderItem.discount + shoesOrderItem.discount

        try app.test(.GET, path, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)

            let orders = try response.content.decode([Order].self)

            XCTAssertEqual(orders[0].discounts, expectedDiscount)
        })
    }

    func testProductCategoryCanBeSavedWithAPI() async throws {
        let timsOrder = try await Order.createTimsOrder()

        try app.test(.POST, path, beforeRequest: { request in
            try request.content.encode(timsOrder)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)

            let order = try response.content.decode(Order.self)

            XCTAssertEqual(order.customerName, timsOrder.customerName)
            XCTAssertEqual(order.address, timsOrder.address)
            XCTAssertEqual(order.email, timsOrder.email)
            XCTAssertEqual(order.city, timsOrder.city)
            XCTAssertEqual(order.state, timsOrder.state)
            XCTAssertEqual(order.zip, timsOrder.zip)
            XCTAssertEqual(order.totalPrice, timsOrder.totalPrice)
        })
    }

    func testProductCategoryCanBeDeletedWithAPI() async throws {
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
            XCTAssertEqual(orders[0].totalPrice, timsOrder.totalPrice)
        })
    }
}

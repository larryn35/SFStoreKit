//
//  OrderItemTests.swift
//
//
//  Created by Larry Nguyen on 4/6/23.
//

@testable import App
import XCTVapor

final class OrderItemTests: XCTestCase {
    var app: Application!
    private let path = "/order-items"
    private var timsOrderID: UUID!
    private var leannesOrderID: UUID!

    override func setUp() async throws {
        app = try Application.testable()

        let timsOrder = try await Order.createTimsOrder(save: app.db)
        timsOrderID = try XCTUnwrap(timsOrder.id)

        let leannesOrder = try await Order.createLeannesOrder(save: app.db)
        leannesOrderID = try XCTUnwrap(leannesOrder.id)
     }

    override func tearDownWithError() throws {
        app.shutdown()
     }

    func testOrderItemsCanBeRetrievedFromAPI() async throws {
        let tshirtOrderItem = try await OrderItem.createShirtOrderItem(for: timsOrderID, save: app.db)
        let _ = try await OrderItem.createShoesOrderItem(for: leannesOrderID, save: app.db)

        try app.test(.GET, path, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)

            let orderItems = try response.content.decode([OrderItem].self)

            XCTAssertEqual(orderItems.count, 2)
            XCTAssertEqual(orderItems[0].name, tshirtOrderItem.name)
            XCTAssertEqual(orderItems[0].image, tshirtOrderItem.image)
            XCTAssertEqual(orderItems[0].color, tshirtOrderItem.color)
            XCTAssertEqual(orderItems[0].size, tshirtOrderItem.size)
            XCTAssertEqual(orderItems[0].price, tshirtOrderItem.price)
            XCTAssertEqual(orderItems[0].discount, tshirtOrderItem.discount)
            XCTAssertEqual(orderItems[0].quantity, tshirtOrderItem.quantity)
        })
    }

    func testOrderItemCanBeSavedWithAPI() async throws {
        let tshirtOrderItemData = OrderItem.createShirtOrderItemData(for: timsOrderID)
        let items = [tshirtOrderItemData]

        try app.test(.POST, path, beforeRequest: { request in
            try request.content.encode(items)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)

            let orderItems = try response.content.decode([OrderItem].self)

            XCTAssertEqual(orderItems[0].name, tshirtOrderItemData.name)
            XCTAssertEqual(orderItems[0].image, tshirtOrderItemData.image)
            XCTAssertEqual(orderItems[0].color, tshirtOrderItemData.color)
            XCTAssertEqual(orderItems[0].size, tshirtOrderItemData.size)
            XCTAssertEqual(orderItems[0].price, tshirtOrderItemData.price)
            XCTAssertEqual(orderItems[0].discount, tshirtOrderItemData.discount)
            XCTAssertEqual(orderItems[0].quantity, tshirtOrderItemData.quantity)
        })
    }

    func testProductCategoryCanBeDeletedWithAPI() async throws {
        let tshirtOrderItem = try await OrderItem.createShirtOrderItem(for: timsOrderID, save: app.db)
        let shoesOrderItem = try await OrderItem.createShoesOrderItem(for: timsOrderID, save: app.db)

        let shirtOrderItemID = try XCTUnwrap(tshirtOrderItem.id)
        let deletePath = path + "/delete/\(shirtOrderItemID)"

        // Expected - Redirect back to /order-items
        try app.test(.DELETE, deletePath, afterResponse: { response in
            if let location = response.headers.last {
                XCTAssertEqual(location.value, path)
            } else {
                XCTFail("Failed to redirect")
            }
        })

        // Expected - Shoes order item remains
        try app.test(.GET, path, afterResponse: { response in
            let orderItems = try response.content.decode([OrderItem].self)

            XCTAssertEqual(orderItems.count, 1)
            XCTAssertEqual(orderItems[0].name, shoesOrderItem.name)
            XCTAssertEqual(orderItems[0].image, shoesOrderItem.image)
            XCTAssertEqual(orderItems[0].color, shoesOrderItem.color)
            XCTAssertEqual(orderItems[0].size, shoesOrderItem.size)
            XCTAssertEqual(orderItems[0].price, shoesOrderItem.price)
            XCTAssertEqual(orderItems[0].discount, shoesOrderItem.discount)
            XCTAssertEqual(orderItems[0].quantity, shoesOrderItem.quantity)
        })
    }
}

//
//  ProductCategoryTests.swift
//  
//
//  Created by Larry Nguyen on 4/4/23.
//

@testable import App
import XCTVapor

final class ProductCategoryTests: XCTestCase {
    var app: Application!
    private let path = "/product-categories"

    override func setUpWithError() throws {
        app = try Application.testable()
     }

    override func tearDownWithError() throws {
        app.shutdown()
     }

    func testProductCategoryCanBeRetrievedFromAPI() async throws {
        let expectedCategory = "tops"
        let expectedDiscount = 20

        let topsCategory = ProductCategory(name: expectedCategory, percentDiscount: 20)
        let dressCategory = ProductCategory(name: "dress", percentDiscount: 0)

        try await [topsCategory, dressCategory].create(on: app.db)

        try app.test(.GET, path, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)

            let categories = try response.content.decode([ProductCategory].self)

            XCTAssertEqual(categories.count, 2)
            XCTAssertEqual(categories[0].id, topsCategory.id)
            XCTAssertEqual(categories[0].name, expectedCategory)
            XCTAssertEqual(categories[0].percentDiscount, expectedDiscount)
        })
    }

    func testProductCategoryCanBeSavedWithAPI() async throws {
        let footwearCategory = ProductCategory(name: "footwear", percentDiscount: 0)

        try app.test(.POST, path, beforeRequest: { request in
            try request.content.encode(footwearCategory)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)

            let category = try response.content.decode(ProductCategory.self)

            XCTAssertEqual(category.name, footwearCategory.name)
            XCTAssertEqual(category.percentDiscount, footwearCategory.percentDiscount)
        })
    }

    func testDuplicateProductCategoryCannotBeSaved() async throws {
        let dressCategory = ProductCategory(name: "dress", percentDiscount: 0)
        try await dressCategory.save(on: app.db)

        let duplicateCategory = ProductCategory(name: "dress", percentDiscount: 20)

        // Expected - 500 error status code
        try app.test(.POST, path, beforeRequest: { request in
            try request.content.encode(duplicateCategory)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .internalServerError)
        })

        // Expected - GET requeest returns 1 product category
        try app.test(.GET, path, afterResponse: { response in
            let categories = try response.content.decode([ProductCategory].self)

            XCTAssertEqual(categories.count, 1)
            XCTAssertEqual(categories[0].name, dressCategory.name)
            XCTAssertEqual(categories[0].percentDiscount, dressCategory.percentDiscount)
        })
    }

    func testProductCategoryCanBePatchedWithAPI() async throws {
        let dressCategory = ProductCategory(name: "typo", percentDiscount: 0)
        try await dressCategory.save(on: app.db)

        let categoryID = try XCTUnwrap(dressCategory.id)
        let updatePath = path + "/update/\(categoryID)"

        let namePatch = ProductCategory.PatchData(name: "dress")
        let discountPatch = ProductCategory.PatchData(percentDiscount: 10)

        // Patch name request
        try app.test(.PATCH, updatePath, beforeRequest: { request in
            try request.content.encode(namePatch)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)

            let category = try response.content.decode(ProductCategory.self)

            // Expected - ProductCategory(name: "dress", percentDiscount: 0)
            XCTAssertEqual(category.name, namePatch.name)
            XCTAssertEqual(category.percentDiscount, dressCategory.percentDiscount)
        })

        // Patch discount request
        try app.test(.PATCH, updatePath, beforeRequest: { request in
            try request.content.encode(discountPatch)
        }, afterResponse: { response in

            let category = try response.content.decode(ProductCategory.self)

            // Expected - ProductCategory(name: "dress", percentDiscount: 10)
            XCTAssertEqual(category.name, namePatch.name)
            XCTAssertEqual(category.percentDiscount, discountPatch.percentDiscount)
        })
    }

    func testProductCategoryCanBeDeletedWithAPI() async throws {
        let topsCategory = ProductCategory(name: "tops", percentDiscount: 0)
        let dressCategory = ProductCategory(name: "dress", percentDiscount: 20)
        try await [topsCategory, dressCategory].create(on: app.db)

        let topsCategoryID = try XCTUnwrap(topsCategory.id)
        let deletePath = path + "/delete/\(topsCategoryID)"

        // Expected - Redirect back to /product-categories
        try app.test(.DELETE, deletePath, afterResponse: { response in
            if let location = response.headers.last {
                XCTAssertEqual(location.value, path)
            } else {
                XCTFail("Failed to redirect")
            }
        })

        // Expected - Tops product category remains
        try app.test(.GET, path, afterResponse: { response in
            let categories = try response.content.decode([ProductCategory].self)

            XCTAssertEqual(categories.count, 1)
            XCTAssertEqual(categories[0].name, dressCategory.name)
            XCTAssertEqual(categories[0].percentDiscount, dressCategory.percentDiscount)
        })
    }
}

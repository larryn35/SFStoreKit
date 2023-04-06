//
//  ProductTests.swift
//
//
//  Created by Larry Nguyen on 4/4/23.
//

@testable import App
import XCTVapor

final class ProductTests: XCTestCase {
    var app: Application!
    private let path = "/products"

    var topsCategory: ProductCategory!
    var bottomsCategory: ProductCategory!

    override func setUp() async throws {
        app = try Application.testable()

        topsCategory = ProductCategory(name: "tops", percentDiscount: 0)
        bottomsCategory = ProductCategory(name: "bottoms", percentDiscount: 20)
        try await [topsCategory, bottomsCategory].create(on: app.db)
     }

    override func tearDownWithError() throws {
        app.shutdown()
     }

    func testProductsCanBeRetrievedFromAPI() async throws {
        let pants = try await savedPants()

        let discount = try XCTUnwrap(bottomsCategory.percentDiscount)
        let expectedDiscountDouble = Double(pants.price) * Double(discount)/100
        let expectedDiscount = Int(expectedDiscountDouble)

        try app.test(.GET, path, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)

            let products = try response.content.decode([Product.ResponseData].self)

            XCTAssertEqual(products.count, 1)
            XCTAssertEqual(products[0].name, pants.name)
            XCTAssertEqual(products[0].description, pants.description)
            XCTAssertEqual(products[0].price, pants.price)
            XCTAssertEqual(products[0].discount, expectedDiscount)
            XCTAssertEqual(products[0].sizes, pants.sizes)
        })
    }

    func testProductCanBeSavedWithAPI() async throws {
        let shirtData = createShirtData()

        try app.test(.POST, path, beforeRequest: { request in
            try request.content.encode(shirtData)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)

            let product = try response.content.decode(Product.self)

            XCTAssertEqual(product.name, shirtData.name)
            XCTAssertEqual(product.description, shirtData.description)
            XCTAssertEqual(product.price, shirtData.price)
            XCTAssertEqual(product.sizes, shirtData.sizes)
        })
    }

    func testDuplicateProductCannotBeSaved() async throws {
        let shirt = try await savedShirt()

        let duplicate = Product.CreateData(categoryName: "tops",
                                           name: shirt.name,
                                           description: "Duplicate",
                                           price: shirt.price,
                                           sizes: shirt.sizes)

        // Expected - 500 error status code
        try app.test(.POST, path, beforeRequest: { request in
            try request.content.encode(duplicate)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .internalServerError)
        })

        // Expected - GET requeest returns 1 product
        try app.test(.GET, path, afterResponse: { response in
            let products = try response.content.decode([Product.ResponseData].self)

            XCTAssertEqual(products.count, 1)
            XCTAssertEqual(products[0].name, shirt.name)
            XCTAssertEqual(products[0].description, shirt.description)
        })
    }

    func testProductCanBePatchedWithAPI() async throws {
        let topsCategory = try XCTUnwrap(topsCategory.id)
        let pants = Product(category: topsCategory,
                            name: "Pants",
                            description: "Fix category",
                            price: 2400, sizes: ["M"])
        try await pants.save(on: app.db)

        let productID = try XCTUnwrap(pants.id)
        let updatePath = path + "/update/\(productID)"

        let patch = Product.PatchData(category: "bottoms", description: "Fixed")

        // Expected - Patch updated product description
        try app.test(.PATCH, updatePath, beforeRequest: { request in
            try request.content.encode(patch)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)

            let product = try response.content.decode(Product.self)

            XCTAssertEqual(product.name, pants.name)
            XCTAssertEqual(product.description, patch.description)
        })

        // Expected - Patch corrected product category to bottoms
        try app.test(.GET, path, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)

            let products = try response.content.decode([Product.ResponseData].self)

            XCTAssertEqual(products[0].name, pants.name)
            XCTAssertEqual(products[0].description, patch.description)
            XCTAssertEqual(products[0].category, patch.category)
        })
    }

    func testProductCategoryCanBeDeletedWithAPI() async throws {
        let shirt = try await savedShirt()
        let pants = try await savedPants()

        let shirtProductID = try XCTUnwrap(shirt.id)
        let deletePath = path + "/delete/\(shirtProductID)"

        // Expected - Redirect back to /products
        try app.test(.DELETE, deletePath, afterResponse: { response in
            if let location = response.headers.last {
                XCTAssertEqual(location.value, path)
            } else {
                XCTFail("Failed to redirect")
            }
        })

        // Expected - Pants remains
        try app.test(.GET, path, afterResponse: { response in
            let products = try response.content.decode([Product.ResponseData].self)

            XCTAssertEqual(products.count, 1)
            XCTAssertEqual(products[0].name, pants.name)
            XCTAssertEqual(products[0].description, pants.description)
        })
    }
}

// MARK: - Helpers

extension ProductTests {
    func savedShirt() async throws -> Product {
        let categoryID = try XCTUnwrap(topsCategory.id)
        let shirt = Product(category: categoryID,
                            name: "T-shirt",
                            description: "Shirt description",
                            price: 800,
                            sizes: ["S", "M", "L"])

        try await shirt.save(on: app.db)
        return shirt
    }

    func createShirtData() -> Product.CreateData {
        return .init(categoryName: topsCategory.name,
                     name: "T-shirt",
                     description: "Shirt description",
                     price: 800,
                     sizes: ["S", "M", "L"])
    }

    func savedPants() async throws -> Product {
        let categoryID = try XCTUnwrap(bottomsCategory.id)
        let pants = Product(category: categoryID,
                            name: "Pants",
                            description: "Pants description",
                            price: 2400,
                            sizes: ["M", "L"])

        try await pants.save(on: app.db)
        return pants
    }

    func createPantsData() -> Product.CreateData {
        return .init(categoryName: bottomsCategory.name,
                     name: "Pants",
                     description: "Pants description",
                     price: 2400,
                     sizes: ["M", "L"])
    }
}

//
//  ColorVariantTests.swift
//
//
//  Created by Larry Nguyen on 4/4/23.
//

@testable import App
import XCTVapor

final class ColorVariantTests: XCTestCase {
    var app: Application!
    private let path = "/variants"

    var shirtProductID: UUID!
    var sweaterProductID: UUID!

    override func setUp() async throws {
        app = try Application.testable()

        let topsCategory = ProductCategory(name: "tops", percentDiscount: 20)
        try await topsCategory.save(on: app.db)
        let categoryID = try XCTUnwrap(topsCategory.id)

        let shirtProduct = try await Product.createShirtProduct(categoryID: categoryID, save: app.db)
        shirtProductID = try XCTUnwrap(shirtProduct.id)

        let sweaterProduct = try await Product.createSweaterProduct(categoryID: categoryID, save: app.db)
        sweaterProductID = try XCTUnwrap(sweaterProduct.id)
     }

    override func tearDownWithError() throws {
        app.shutdown()
     }

    func testColorVariantsCanBeRetrievedFromAPI() async throws {
        let blueVariant = try await ColorVariant.createBlueVariant(productID: shirtProductID, save: app.db)

        try app.test(.GET, path, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)

            let variants = try response.content.decode([ColorVariant].self)

            XCTAssertEqual(variants.count, 1)
            XCTAssertEqual(variants[0].color, blueVariant.color)
            XCTAssertEqual(variants[0].hex, blueVariant.hex)
            XCTAssertEqual(variants[0].image, blueVariant.image)
        })
    }

    func testColorVariantCanBeSavedWithAPI() async throws {
        let variantData = ColorVariant.createBlueVariantData(productID: shirtProductID)
        let variants = [variantData]

        try app.test(.POST, path, beforeRequest: { request in
            try request.content.encode(variants)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)

            let variants = try response.content.decode([ColorVariant].self)

            XCTAssertEqual(variants.count, 1)
            XCTAssertEqual(variants[0].color, variantData.color)
            XCTAssertEqual(variants[0].hex, variantData.hex)
            XCTAssertEqual(variants[0].image, variantData.image)
        })
    }

    func testColorVariantsForProductCanBeRetrievedFromAPI() async throws {
        // Sweater variants
        let _ = try await ColorVariant.createRedVariant(productID: sweaterProductID, save: app.db)

        // Shirt variants
        let blueVariant = try await ColorVariant.createBlueVariant(productID: shirtProductID, save: app.db)
        let _ = try await ColorVariant.createGreenVariant(productID: shirtProductID, save: app.db)

        let productIDPath = path + "/\(shirtProductID!)"

        // Expected - Fetch shirt variants
        try app.test(.GET, productIDPath, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)

            let variants = try response.content.decode([ColorVariant].self)

            XCTAssertEqual(variants.count, 2)
            XCTAssertEqual(variants[0].color, blueVariant.color)
            XCTAssertEqual(variants[0].hex, blueVariant.hex)
            XCTAssertEqual(variants[0].image, blueVariant.image)
        })
    }

    func testColorMustBeUniqueForProduct() async throws {
        let redVariant = ColorVariant.createBlueVariantData(productID: shirtProductID)

        let duplicate = ColorVariant.CreateData(productID: shirtProductID,
                                                color: redVariant.color,
                                                hex: "7f0000",
                                                image: "duplicate-7f0000")
        let variants = [redVariant, duplicate]

        // Expected - 500 error status code
        try app.test(.POST, path, beforeRequest: { request in
            try request.content.encode(variants)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .internalServerError)
        })

        // Expected - GET request returns no color variants
        try app.test(.GET, path, afterResponse: { response in
            let variants = try response.content.decode([ColorVariant].self)

            XCTAssertEqual(variants.count, 0)
        })
    }

    func testSameColorMayBeUsedForDifferentProducts() async throws {
        let blueShirtVariant = ColorVariant.createBlueVariantData(productID: shirtProductID)
        let blueSweaterVariant = ColorVariant.createBlueVariantData(productID: sweaterProductID)

        let variants = [blueShirtVariant, blueSweaterVariant]

        try app.test(.POST, path, beforeRequest: { request in
            try request.content.encode(variants)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)

            let variants = try response.content.decode([ColorVariant].self)

            XCTAssertEqual(variants.count, 2)
        })
    }

    func testColorVariantCanBePatchedWithAPI() async throws {
        let blueVariant = try await ColorVariant.createBlueVariant(productID: shirtProductID, save: app.db)
        let variantID = try XCTUnwrap(blueVariant.id)

        let updatePath = path + "/update/\(variantID)"

        let patch = ColorVariant.PatchData(color: "Dark blue", hex: "063970")

        // Expected - Color and hex updated, image unchanged
        try app.test(.PATCH, updatePath, beforeRequest: { request in
            try request.content.encode(patch)
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)

            let variant = try response.content.decode(ColorVariant.self)

            XCTAssertEqual(variant.color, patch.color)
            XCTAssertEqual(variant.hex, patch.hex)
            XCTAssertEqual(variant.image, blueVariant.image)
        })
    }

    func testColorVariantCanBeDeletedWithAPI() async throws {
        let blueVariant = try await ColorVariant.createBlueVariant(productID: sweaterProductID, save: app.db)
        let redVariant = try await ColorVariant.createRedVariant(productID: shirtProductID, save: app.db)

        let blueVariantID = try XCTUnwrap(blueVariant.id)
        let deletePath = path + "/delete/\(blueVariantID)"

        // Expected - Redirect back to /variants
        try app.test(.DELETE, deletePath, afterResponse: { response in
            if let location = response.headers.last {
                XCTAssertEqual(location.value, path)
            } else {
                XCTFail("Failed to redirect")
            }
        })

        // Expected - Red variant remains
        try app.test(.GET, path, afterResponse: { response in
            let variants = try response.content.decode([ColorVariant].self)

            XCTAssertEqual(variants.count, 1)
            XCTAssertEqual(variants[0].color, redVariant.color)
            XCTAssertEqual(variants[0].hex, redVariant.hex)
            XCTAssertEqual(variants[0].image, redVariant.image)
        })
    }
}

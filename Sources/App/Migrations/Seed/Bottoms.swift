//
//  Seed+Bottoms.swift
//
//
//  Created by Larry Nguyen on 4/6/23.
//

import Fluent
import Vapor
import Foundation

extension Seed {
    struct Bottoms: AsyncMigration {
        let categoryID = UUID()

        func prepare(on database: Database) async throws {
            let bottomsCategory = ProductCategory(id: categoryID,
                                                  name: "bottoms", percentDiscount: 0)
            try await bottomsCategory.save(on: database)

            let swimmingShortsModel = SwimmingShorts(categoryID: categoryID)
            let swimmingShorts = swimmingShortsModel.createProduct()
            let swimmingShortsVariants = swimmingShortsModel.createVariants()

            let shortsModel = Shorts(categoryID: categoryID)
            let shorts = shortsModel.createProduct()
            let shortsVariants = shortsModel.createVariants()

            let stripedPantsModel = StripedPants(categoryID: categoryID)
            let stripedPants = stripedPantsModel.createProduct()
            let stripedPantsVariants = stripedPantsModel.createVariants()

            let fittedPantsModel = FittedPants(categoryID: categoryID)
            let fittedPants = fittedPantsModel.createProduct()
            let fittedPantsVariants = fittedPantsModel.createVariants()

            let sweatpantsModel = Sweatpants(categoryID: categoryID)
            let sweatpants = sweatpantsModel.createProduct()
            let sweatpantsVariants = sweatpantsModel.createVariants()

            let pantsModel = Pants(categoryID: categoryID)
            let pants = pantsModel.createProduct()
            let pantsVariants = pantsModel.createVariants()

            let products = [
                swimmingShorts, shorts, stripedPants, fittedPants, sweatpants, pants
            ]

            let variants = [
                swimmingShortsVariants, shortsVariants, stripedPantsVariants, fittedPantsVariants, sweatpantsVariants, pantsVariants
            ]
                .flatMap({ $0 })

            try await products.create(on: database)
            try await variants.create(on: database)
        }

        func revert(on database: Database) async throws {
            try await ProductCategory
                .query(on: database)
                .filter(\.$name == "Bottoms")
                .delete()
        }
    }
}

fileprivate struct SwimmingShorts {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Swimming shorts",
                description: "Dive into summer with our vibrant and colorful swimming shorts, designed to help you make a splash in style.",
                price: 900,
                sizes: ["S", "M", "L"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Cabaret",
                         hex: "D83E63",
                         image: "swimmingshorts-D83E63"),

            ColorVariant(product: productID,
                         color: "Turquoise Pearl",
                         hex: "3EBBD8",
                         image: "swimmingshorts-3EBBD8")
        ]
    }
}

fileprivate struct Shorts {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Shorts",
                description: "Update your summer wardrobe with our stylish and trendy earth-toned shorts, designed to add a touch of nature-inspired charm to your outfit.",
                price: 1200,
                sizes: ["S", "M", "L"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Hemp",
                         hex: "8D746F",
                         image: "shorts-8D746F"),

            ColorVariant(product: productID,
                         color: "Mineral Green",
                         hex: "455E55",
                         image: "shorts-455E55")
        ]
    }
}

fileprivate struct StripedPants {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Striped pants",
                description: "Made with high-quality and comfortable materials, these pants are perfect for adding a touch of fashion-forward flair to your outfit.",
                price: 1800,
                sizes: ["S", "M", "L"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "San Juan",
                         hex: "314077",
                         image: "stripedpants-314077"),

            ColorVariant(product: productID,
                         color: "Spectra",
                         hex: "2B5853",
                         image: "stripedpants-2B5853"),

            ColorVariant(product: productID,
                         color: "Roof Terracotta",
                         hex: "AD2020",
                         image: "stripedpants-AD2020")
        ]
    }
}

fileprivate struct FittedPants {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Fitted pants",
                description: "The comfortable and flexible materials make them ideal for all-day wear, while the sleek and modern look creates a stylish and put-together appearance.",
                price: 2800,
                sizes: ["XS", "S", "M", "L"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Horizon",
                         hex: "5F86A1",
                         image: "fittedpants-5F86A1"),

            ColorVariant(product: productID,
                         color: "Amethyst",
                         hex: "9368C9",
                         image: "fittedpants-9368C9")
        ]
    }
}

fileprivate struct Sweatpants {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Sweatpants",
                description: "Whether you're binge-watching your favorite show or hitting the gym, our sweatpants are the perfect choice for ultimate comfort and style.",
                price: 1400,
                sizes: ["S", "M", "L"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Scooter",
                         hex: "3DBADA",
                         image: "sweatpants-3DBADA"),

            ColorVariant(product: productID,
                         color: "Pastel Green",
                         hex: "82D67D",
                         image: "sweatpants-82D67D"),

            ColorVariant(product: productID,
                         color: "Antique Brass",
                         hex: "CC9461",
                         image: "sweatpants-CC9461")
        ]
    }
}

fileprivate struct Pants {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Pants",
                description: "The versatile and classic design features a slim fit and ankle-length cut, making them perfect for dressing up or down.",
                price: 2200,
                sizes: ["S", "M", "L", "XL"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Hemlock",
                         hex: "5E563C",
                         image: "pants-5E563C"),

            ColorVariant(product: productID,
                         color: "Black Coral Pearl",
                         hex: "555D68",
                         image: "pants-555D68"),

            ColorVariant(product: productID,
                         color: "Kashmir Blue",
                         hex: "496998",
                         image: "pants-496998"),

            ColorVariant(product: productID,
                         color: "Pine",
                         hex: "4AA483",
                         image: "pants-4AA483")
        ]
    }
}

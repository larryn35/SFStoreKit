//
//  Seed+Dresses.swift
//  
//
//  Created by Larry Nguyen on 4/6/23.
//

import Fluent
import Foundation

extension Seed {
    struct Dresses: AsyncMigration {
        func prepare(on database: Database) async throws {
            let categoryID = UUID()
            let dressesCategpry = ProductCategory(id: categoryID,
                                                  name: "dresses", percentDiscount: 0)
            try await dressesCategpry.save(on: database)

            let sundressModel = Sundress(categoryID: categoryID)
            let sundress = sundressModel.createProduct()
            let sundressVariants = sundressModel.createVariants()

            let longSleeveModel = LongSleeved(categoryID: categoryID)
            let longSleeve = longSleeveModel.createProduct()
            let longSleeveVariants = longSleeveModel.createVariants()

            let dressModel = Dress(categoryID: categoryID)
            let dress = dressModel.createProduct()
            let dressVariants = dressModel.createVariants()

            let cocktailDressModel = Cocktail(categoryID: categoryID)
            let cocktailDress = cocktailDressModel.createProduct()
            let cocktailDressVariants = cocktailDressModel.createVariants()

            let products = [
                sundress, longSleeve, dress, cocktailDress
            ]

            let variants = [
                sundressVariants, longSleeveVariants, dressVariants, cocktailDressVariants
            ]
                .flatMap({ $0 })

            try await products.create(on: database)
            try await variants.create(on: database)
        }

        func revert(on database: Database) async throws {
            try await ProductCategory
                .query(on: database)
                .filter(\.$name == "Dresses")
                .delete()
        }
    }
}

fileprivate struct Sundress {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Sundress",
                description: "Made with lightweight and comfortable materials, these sundresses are designed to keep you cool and stylish all day long.",
                price: 2000,
                sizes: ["S", "M", "L", "XL"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Emerald",
                         hex: "4EC67C",
                         image: "sundress-4EC67C"),

            ColorVariant(product: productID,
                         color: "Bright Sun",
                         hex: "FFD53E",
                         image: "sundress-FFD53E")
        ]
    }
}

fileprivate struct LongSleeved {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Long sleeved",
                description: "Make a statement with our elegant and sophisticated long-sleeved dresses, perfect for any formal occasion.",
                price: 2600,
                sizes: ["S", "M", "L"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Melrose",
                         hex: "94A5FF",
                         image: "longsleevedress-94A5FF"),

            ColorVariant(product: productID,
                         color: "Bright Sun",
                         hex: "FFD53E",
                         image: "longsleevedress-FFD53E")
        ]
    }
}

fileprivate struct Dress {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Dress",
                description: "Whether you're attending a wedding or a night out with friends, our dresses are the perfect choice for effortless style and comfort.",
                price: 2000,
                sizes: ["S", "M", "L"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Alto",
                         hex: "E0E0E0",
                         image: "dress-E0E0E0"),

            ColorVariant(product: productID,
                         color: "Geraldine",
                         hex: "FB9C87",
                         image: "dress-FB9C87"),

            ColorVariant(product: productID,
                         color: "Scooter",
                         hex: "3DBADA",
                         image: "dress-3DBADA")
        ]
    }
}

fileprivate struct Cocktail {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Cocktail dress",
                description: "The fabric is soft to the touch and drapes beautifully, creating a flowing and elegant look that's sure to impress.",
                price: 2200,
                sizes: ["S", "M", "L"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Chestnut Rose",
                         hex: "CB525F",
                         image: "cocktaildress-CB525F"),

            ColorVariant(product: productID,
                         color: "Butterfly Bush",
                         hex: "4F58A1",
                         image: "cocktaildress-4F58A1"),

            ColorVariant(product: productID,
                         color: "Cutty Sark",
                         hex: "497673",
                         image: "cocktaildress-497673")
        ]
    }
}


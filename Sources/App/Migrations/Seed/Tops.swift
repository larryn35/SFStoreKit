//
//  Seed+Tops.swift
//  
//
//  Created by Larry Nguyen on 4/6/23.
//

import Fluent
import Foundation

struct Seed {
    struct Tops: AsyncMigration {
        func prepare(on database: Database) async throws {
            let categoryID = UUID()
            let topsCategpry = ProductCategory(id: categoryID,
                                               name: "tops", percentDiscount: 20)
            try await topsCategpry.save(on: database)

            let tshirtModel = TShirt(categoryID: categoryID)
            let tshirt = tshirtModel.createProduct()
            let tshirtVariants = tshirtModel.createVariants()

            let tankTopModel = TankTop(categoryID: categoryID)
            let tankTop = tankTopModel.createProduct()
            let tankTopVariants = tankTopModel.createVariants()

            let poloModel = Polo(categoryID: categoryID)
            let polo = poloModel.createProduct()
            let poloVariants = poloModel.createVariants()

            let turtleneckModel = Turtleneck(categoryID: categoryID)
            let turtleneck = turtleneckModel.createProduct()
            let turtleneckVariants = turtleneckModel.createVariants()

            let jerseyModel = Jersey(categoryID: categoryID)
            let jersey = jerseyModel.createProduct()
            let jerseyVariants = jerseyModel.createVariants()

            let signaturePoloModel = SignaturePolo(categoryID: categoryID)
            let signaturePolo = signaturePoloModel.createProduct()
            let signaturePoloVariants = signaturePoloModel.createVariants()

            let athleticTankTopModel = AthleticTanktop(categoryID: categoryID)
            let athleticTankTop = athleticTankTopModel.createProduct()
            let athleticTankTopVariants = athleticTankTopModel.createVariants()

            let sweaterModel = Sweater(categoryID: categoryID)
            let sweater = sweaterModel.createProduct()
            let sweaterVariants = sweaterModel.createVariants()

            let products = [
                tshirt, tankTop, polo, turtleneck, jersey, signaturePolo, athleticTankTop, sweater
            ]

            let variants = [
                tshirtVariants, tankTopVariants, poloVariants, turtleneckVariants, jerseyVariants, signaturePoloVariants, athleticTankTopVariants, sweaterVariants
            ]
                .flatMap({ $0 })

            try await products.create(on: database)
            try await variants.create(on: database)
        }

        func revert(on database: Database) async throws {
            try await ProductCategory
                .query(on: database)
                .filter(\.$name == "Tops")
                .delete()
        }
    }
}

fileprivate struct TShirt {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "T-shirt",
                description: "Introducing our classic and versatile t-shirt, perfect for any occasion. Made with soft and comfortable cotton, this t-shirt is lightweight and breathable, ensuring all-day comfort.",
                price: 1200,
                sizes: ["S", "M", "L"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Dusty Gray",
                         hex: "9E8A8A",
                         image: "tshirt-9E8A8A"),

            ColorVariant(product: productID,
                         color: "Tan Hide",
                         hex: "FC9C5E",
                         image: "tshirt-FC9C5E"),

            ColorVariant(product: productID,
                         color: "Pickled Bluewood",
                         hex: "35455E",
                         image: "tshirt-35455E"),
        ]
    }
}

fileprivate struct TankTop {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Tank top",
                description: "This tank top offers exceptional durability and a soft and comfortable fit. The modern and versatile design features a flattering scoop neckline and a relaxed fit, making it perfect for any occasion.",
                price: 800,
                sizes: ["S", "M", "L"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Scooter",
                         hex: "3DBADA",
                         image: "tanktop-3DBADA"),

            ColorVariant(product: productID,
                         color: "Emerald",
                         hex: "4EC67C",
                         image: "tanktop-4EC67C"),

            ColorVariant(product: productID,
                         color: "Sunglow",
                         hex: "FDD54F",
                         image: "tanktop-FDD54F"),
        ]
    }
}

fileprivate struct Polo {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Polo shirt",
                description: "The classic design features a traditional collar and button-up front, creating a sophisticated and refined look.",
                price: 1600,
                sizes: ["S", "M", "L"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Emerald",
                         hex: "4EC67C",
                         image: "polo-4EC67C"),

            ColorVariant(product: productID,
                         color: "Abbey",
                         hex: "44464A",
                         image: "polo-44464A")
        ]
    }
}

fileprivate struct Turtleneck {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Turtleneck sweater",
                description: "Bring some joy and positivity to your wardrobe with our cozy and stylish sweater featuring a smile design.",
                price: 2800,
                sizes: ["S", "M", "L"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Shuttle Gray",
                         hex: "65676C",
                         image: "turtleneck-65676C"),

            ColorVariant(product: productID,
                         color: "Blueberry",
                         hex: "745EFC",
                         image: "turtleneck-745EFC"),

            ColorVariant(product: productID,
                         color: "Ghost",
                         hex: "CAC8D8",
                         image: "turtleneck-CAC8D8")
        ]
    }
}

fileprivate struct Jersey {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Jersey",
                description: "Get ready to hit the court in style with our high-quality basketball jersey.",
                price: 1600,
                sizes: ["S", "M", "L", "XL"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Chestnut Rose",
                         hex: "CC4F60",
                         image: "jersey-CC4F60"),

            ColorVariant(product: productID,
                         color: "Indigo",
                         hex: "4F72CC",
                         image: "jersey-4F72CC"),

            ColorVariant(product: productID,
                         color: "Fuchsia",
                         hex: "C94FCC",
                         image: "jersey-C94FCC"),

            ColorVariant(product: productID,
                         color: "Persian Plum",
                         hex: "661A24",
                         image: "jersey-661A24")
        ]
    }
}

fileprivate struct SignaturePolo {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Signature Polo",
                description: "Crafted with the finest materials, this polo shirt offers exceptional comfort and durability, ensuring it lasts for years to come.",
                price: 3200,
                sizes: ["S", "M", "L"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Shuttle Gray",
                         hex: "65676C",
                         image: "signaturepolo-65676C"),

            ColorVariant(product: productID,
                         color: "Kashmir Blue",
                         hex: "526594",
                         image: "signaturepolo-526594")
        ]
    }
}

fileprivate struct AthleticTanktop {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Athletic Tanktop",
                description: "The modern and sleek design features a flattering fit and stylish detailing, making it perfect for both gym sessions and outdoor activities.",
                price: 2000,
                sizes: ["S", "M", "L"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Emerald",
                         hex: "4EC67C",
                         image: "atheletictank-4EC67C"),

            ColorVariant(product: productID,
                         color: "Purple Heart",
                         hex: "6D4EC6",
                         image: "atheletictank-6D4EC6"),

            ColorVariant(product: productID,
                         color: "Mine Shaft",
                         hex: "303030",
                         image: "atheletictank-303030"),

            ColorVariant(product: productID,
                         color: "Flamenco",
                         hex: "FE800C",
                         image: "atheletictank-FE800C")
        ]
    }
}

fileprivate struct Sweater {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Sweater",
                description: "Elevate your sweater collection with our stylish and trendy sweater featuring stripes on the sleeves.",
                price: 2500,
                sizes: ["S", "M", "L"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Chestnut Rose",
                         hex: "CC4F60",
                         image: "sweater-CC4F60"),

            ColorVariant(product: productID,
                         color: "Pastel Green",
                         hex: "7EE288",
                         image: "sweater-7EE288")
        ]
    }
}

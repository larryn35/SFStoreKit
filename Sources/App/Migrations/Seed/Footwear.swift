//
//  Seed+Footwear.swift
//
//
//  Created by Larry Nguyen on 4/6/23.
//

import Fluent
import Vapor
import Foundation

extension Seed {
    struct Footwear: AsyncMigration {
        let categoryID = UUID()

        func prepare(on database: Database) async throws {
            let footwearCategory = ProductCategory(id: categoryID,
                                                   name: "footwear", percentDiscount: 0)
            try await footwearCategory.save(on: database)

            let lowTopsModel = LowTops(categoryID: categoryID)
            let lowTops = lowTopsModel.createProduct()
            let lowTopsVariants = lowTopsModel.createVariants()

            let highHeelsModel = HighHeels(categoryID: categoryID)
            let highHeels = highHeelsModel.createProduct()
            let highHeelsVariants = highHeelsModel.createVariants()

            let dressShoesModel = DressShoes(categoryID: categoryID)
            let dressShoes = dressShoesModel.createProduct()
            let dressShoesVariants = dressShoesModel.createVariants()

            let sandalsModel = Sandals(categoryID: categoryID)
            let sandals = sandalsModel.createProduct()
            let sandalsVariants = sandalsModel.createVariants()

            let rainbootsModel = Rainboots(categoryID: categoryID)
            let rainboots = rainbootsModel.createProduct()
            let rainbootsVariants = rainbootsModel.createVariants()

            let bootsModel = Boots(categoryID: categoryID)
            let boots = bootsModel.createProduct()
            let bootsVariants = bootsModel.createVariants()

            let sneakersModel = Sneakers(categoryID: categoryID)
            let sneakers = sneakersModel.createProduct()
            let sneakersVariants = sneakersModel.createVariants()

            let runningShoesModel = RunningShoes(categoryID: categoryID)
            let runningShoes = runningShoesModel.createProduct()
            let runningShoesVariants = runningShoesModel.createVariants()

            let products = [
                lowTops, highHeels, dressShoes, sandals, rainboots, boots, sneakers, runningShoes
            ]

            let variants = [
                lowTopsVariants, highHeelsVariants, dressShoesVariants, sandalsVariants, rainbootsVariants, bootsVariants, sneakersVariants, runningShoesVariants
            ]
                .flatMap({ $0 })

            try await products.create(on: database)
            try await variants.create(on: database)
        }

        func revert(on database: Database) async throws {
            try await ProductCategory
                .query(on: database)
                .filter(\.$name == "Footwear")
                .delete()
        }
    }
}

fileprivate struct LowTops {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Low tops",
                description: "These shoes are characterized by their low-cut design that sits below the ankle, providing a comfortable and casual look that's perfect for everyday wear.",
                price: 4200,
                sizes: ["8", "9", "10", "11", "12"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Emerald",
                         hex: "57C983",
                         image: "lowtops-57C983"),

            ColorVariant(product: productID,
                         color: "New Car",
                         hex: "215DB8",
                         image: "lowtops-215DB8"),

            ColorVariant(product: productID,
                         color: "Medium Purple",
                         hex: "9251E3",
                         image: "lowtops-9251E3")
        ]
    }
}

fileprivate struct HighHeels {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "High heels",
                description: "Whether you're dressing up for a formal event or adding a touch of sophistication to your everyday look, these high heels are sure to turn heads.",
                price: 6000,
                sizes: ["5", "6", "7", "8"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Chambray",
                         hex: "3A3E99",
                         image: "heels-3A3E99"),

            ColorVariant(product: productID,
                         color: "Tall Poppy",
                         hex: "B42837",
                         image: "heels-B42837")
        ]
    }
}

fileprivate struct DressShoes {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Dress shoes",
                description: "The high-quality construction ensures that they will last for years to come, making them a valuable investment in your formal wardrobe.",
                price: 5400,
                sizes: ["7", "8", "9", "10"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Irish Coffee",
                         hex: "593B20",
                         image: "dressshoes-593B20")
        ]
    }
}

fileprivate struct Sandals {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Sandals",
                description: "Our sandals are designed with comfort in mind, featuring a cushioned footbed and a supportive sole that provides ample arch support and shock absorption. This ensures that you can wear them all day without experiencing any discomfort or pain.",
                price: 2200,
                sizes: ["S", "M", "L"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Inchworm",
                         hex: "94EA76",
                         image: "sandal-94EA76"),

            ColorVariant(product: productID,
                         color: "Flamenco",
                         hex: "FE800C",
                         image: "sandal-FE800C"),

            ColorVariant(product: productID,
                         color: "Bright Sun",
                         hex: "FFD53E",
                         image: "sandal-FFD53E")
        ]
    }
}

fileprivate struct Rainboots {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Rainboots",
                description: "Our rain boots are crafted from high-quality rubber or synthetic materials that are waterproof and durable, ensuring that they can withstand even the wettest and muddiest conditions.",
                price: 2200,
                sizes: ["6", "7", "8", "9", "10"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Scooter",
                         hex: "3DBADA",
                         image: "rainboots-3DBADA"),

            ColorVariant(product: productID,
                         color: "Bright Sun",
                         hex: "FFD53E",
                         image: "rainboots-FFD53E"),

            ColorVariant(product: productID,
                         color: "Flamingo",
                         hex: "EE5D3D",
                         image: "rainboots-EE5D3D"),

            ColorVariant(product: productID,
                         color: "Fuchsia",
                         hex: "C94FCC",
                         image: "rainboots-C94FCC")
        ]
    }
}

fileprivate struct Boots {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Boots",
                description: "Our boots feature a comfortable footbed and a non-slip sole that provides ample traction on any terrain, ensuring that you can hike or walk with confidence and ease.",
                price: 4200,
                sizes: ["7", "8", "9", "10"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Emerald",
                         hex: "4EC67C",
                         image: "boots-4EC67C"),

            ColorVariant(product: productID,
                         color: "Mule Fawn",
                         hex: "93522C",
                         image: "boots-93522C")
        ]
    }
}

fileprivate struct Sneakers {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Sneakers",
                description: "Introducing our stylish and trendy sneakers, featuring a bold and eye-catching star design! Crafted from high-quality materials, such as durable canvas or soft leather, our sneakers are designed to be both comfortable and stylish.",
                price: 6200,
                sizes: ["9", "10", "11", "12"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Lotus",
                         hex: "783434",
                         image: "sneakers-783434"),

            ColorVariant(product: productID,
                         color: "Scorpion",
                         hex: "5C5858",
                         image: "sneakers-5C5858")
        ]
    }
}

fileprivate struct RunningShoes {
    let categoryID: UUID
    private let productID = UUID()

    func createProduct() -> Product {
        Product(id: productID,
                category: categoryID,
                name: "Running Shoes",
                description: "Our running shoes are designed for comfort and performance, with a cushioned footbed and a supportive sole that provides ample arch support and shock absorption.",
                price: 5900,
                sizes: ["8", "9", "10", "11"])
    }

    func createVariants() -> [ColorVariant] {
        [
            ColorVariant(product: productID,
                         color: "Amethyst",
                         hex: "9666C6",
                         image: "runningshoes-9666C6"),

            ColorVariant(product: productID,
                         color: "Chestnut Rose",
                         hex: "CC4F60",
                         image: "runningshoes-CC4F60"),

            ColorVariant(product: productID,
                         color: "Vista Blue",
                         hex: "9AD7B6",
                         image: "runningshoes-9AD7B6")
        ]
    }
}


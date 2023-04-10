//
//  ProductController.swift
//  
//
//  Created by Larry Nguyen on 4/4/23.
//

import Fluent
import Vapor

struct ProductController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let products = routes.grouped("products")
        products.get(use: index)
        products.get(":categoryName", use: fetchProductsForCategory)
        products.post(use: create)
        products.patch("update", ":productID", use: updateProduct)
        products.delete("delete", ":productID", use: delete)
    }

    // GET Request: /products route
    func index(req: Request) async throws -> [Product.ResponseData] {
        let products = try await Product.query(on: req.db)
            .with(\.$category)
            .with(\.$variants)
            .all()

        return products.map { Product.ResponseData(product: $0) }
    }

    // GET Request: /products/:categoryName route
    func fetchProductsForCategory(req: Request) async throws -> [Product] {
        guard let categoryName = req.parameters.get("categoryName") else {
            throw Abort(.notFound)
        }

        let category = try await ProductCategory.query(on: req.db)
            .filter(\.$name == categoryName.lowercased())
            .first()

        if let category {
            return try await category.$products.query(on: req.db).all()
        } else {
            throw Abort(.notFound)
        }
    }

    // POST Request: /products route
    func create(req: Request) async throws -> Product {
        let data = try req.content.decode(Product.CreateData.self)

        // Find ProductCategory for product
        guard let category = try await ProductCategory.query(on: req.db)
            .filter(\.$name == data.categoryName)
            .first()
        else {
            throw Abort(.badRequest)
        }

        let product = Product(data: data)

        // Assign ProductCategory ID to product
        if let id = category.id {
            product.$category.id = id
            try await product.create(on: req.db)
            return product
        } else {
            print("Unable to get id")
            throw Abort(.badRequest)
        }
    }

    // PATCH Request: /products/update/:productID route
    func updateProduct(req: Request) async throws -> Product {
        let patch = try req.content.decode(Product.PatchData.self)

        guard let product = try await Product.find(req.parameters.get("productID"), on: req.db) else {
            throw Abort(.notFound)
        }

        if let updatedCategory = patch.category {
            // Find ProductCategory for product's new category
            guard let category = try await ProductCategory.query(on: req.db)
                .filter(\.$name == updatedCategory)
                .first()
            else {
                throw Abort(.badRequest)
            }

            // Update product's category ID
            if let id = category.id {
                product.$category.id = id
            } else {
                print("Unable to get id")
                throw Abort(.badRequest)
            }
        }

        if let updatedName = patch.name {
            product.name = updatedName
        }

        if let updatedDescription = patch.description {
            product.description = updatedDescription
        }

        if let updatedPrice = patch.price {
            product.price = updatedPrice
        }

        if let updatedSizes = patch.sizes {
            product.sizes = updatedSizes
        }

        if product.hasChanges {
            try await product.save(on: req.db)
            return product
        } else {
            throw Abort(.notModified)
        }
    }

    // DELETE Request: /products/delete/:productID route
    func delete(req: Request) async throws -> Response {
        guard let product = try await Product.find(req.parameters.get("productID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await product.delete(on: req.db)
        return req.redirect(to: "/products")
    }
}

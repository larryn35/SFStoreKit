//
//  ProductCategoryController.swift
//  
//
//  Created by Larry Nguyen on 4/4/23.
//

import Vapor

struct ProductCategoryController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let categories = routes.grouped("product-categories")
        categories.get(use: index)
        categories.post(use: create)
        categories.patch("update", ":categoryID", use: updateCategory)
        categories.delete("delete", ":categoryID", use: delete)
    }

    // GET Request: /product-categories route
    func index(req: Request) async throws -> [ProductCategory] {
        try await ProductCategory.query(on: req.db).all()
    }

    // POST Request: /product-categories route
    func create(req: Request) async throws -> ProductCategory {
        let category = try req.content.decode(ProductCategory.self)
        try await category.save(on: req.db)
        return category
    }

    // PATCH Request: /product-categories/update/:categoryID
    func updateCategory(req: Request) async throws -> ProductCategory {
        let patch = try req.content.decode(ProductCategory.PatchData.self)

        guard let category = try await ProductCategory.find(req.parameters.get("categoryID"), on: req.db) else {
            throw Abort(.notFound)
        }

        if let updatedCategory = patch.name {
            category.name = updatedCategory
        }

        if let updatedDiscount = patch.percentDiscount {
            category.percentDiscount = updatedDiscount
        }

        try await category.save(on: req.db)
        return category
    }

    // DELETE Request: /product-categories/delete/:categoryID
    func delete(req: Request) async throws -> Response {
        guard let category = try await ProductCategory.find(req.parameters.get("categoryID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await category.delete(on: req.db)
        return req.redirect(to: "/product-categories")
    }
}

//
//  ColorVariantController.swift
//  
//
//  Created by Larry Nguyen on 4/4/23.
//

import Vapor

struct ColorVariantController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let variants = routes.grouped("variants")
        variants.get(use: index)
        variants.get(":productID", use: fetchVariantsForProduct)
        variants.post(use: create)
        variants.patch("update", ":variantID", use: updateVariant)
        variants.delete("delete", ":variantID", use: delete)
    }

    // GET Request: /variants/all route
    func index(req: Request) async throws -> [ColorVariant] {
        var variants: [ColorVariant] = []
        let products = try await Product.query(on: req.db).with(\.$variants).all()

        for product in products {
            variants.append(contentsOf: product.variants)
        }

        return variants
    }

    // GET Request: /variants/:productID route
    func fetchVariantsForProduct(req: Request) async throws -> [ColorVariant] {
        guard let product = try await Product.find(req.parameters.get("productID"), on: req.db) else {
            throw Abort(.notFound)
        }

        let variants = try await product.$variants.get(on: req.db)
        return variants
    }

    // POST Request: /variants route
    func create(req: Request) async throws -> [ColorVariant] {
        let content = req.content
        print(content)
        let data = try req.content.decode([ColorVariant.CreateData].self)
        let variants = data.map { ColorVariant(data: $0) }

        try await variants.create(on: req.db)
        return variants
    }

    // PATCH Request: /variants/update/:variantID route
    func updateVariant(req: Request) async throws -> ColorVariant {
        let patch = try req.content.decode(ColorVariant.PatchData.self)

        guard let variant = try await ColorVariant.find(req.parameters.get("variantID"), on: req.db) else {
            throw Abort(.notFound)
        }

        if let updatedColor = patch.color {
            variant.color = updatedColor
        }

        if let updatedHex = patch.hex {
            variant.hex = updatedHex
        }

        if let updatedImage = patch.image {
            variant.image = updatedImage
        }

        if variant.hasChanges {
            try await variant.save(on: req.db)
            return variant
        } else {
            throw Abort(.notModified)
        }
    }

    // DELETE Request: /variants/delete/:variantID route
    func delete(req: Request) async throws -> Response {
        guard let variant = try await ColorVariant.find(req.parameters.get("variantID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await variant.delete(on: req.db)
        return req.redirect(to: "/variants")
    }
}

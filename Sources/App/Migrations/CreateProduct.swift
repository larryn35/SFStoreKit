//
//  CreateProduct.swift
//  
//
//  Created by Larry Nguyen on 4/4/23.
//

import Fluent

extension Product {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(Product.schema)
                .id()
                .field(.Product.categoryID, .uuid, .required)
                .foreignKey(.Product.categoryID,
                            references: ProductCategory.schema, .id)
                .field(.name, .string, .required)
                .unique(on: .name)
                .field(.Product.description, .string, .required)
                .field(.Product.price, .int, .required)
                .field(.Product.sizes, .array(of: .string), .required)
                .field(.createdAt, .date)
                .field(.updatedAt, .date)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(Product.schema).delete()
        }
    }
}


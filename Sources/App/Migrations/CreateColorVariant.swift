//
//  CreateColorVariant.swift
//  
//
//  Created by Larry Nguyen on 4/4/23.
//

import Fluent

extension ColorVariant {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(ColorVariant.schema)
                .id()
                .field(.ColorVariant.productID, .uuid, .required)
                .foreignKey(.ColorVariant.productID,
                            references: Product.schema, .id,
                            onDelete: .cascade)
                .field(.ColorVariant.color, .string, .required)
                .unique(on: .ColorVariant.color, .ColorVariant.productID)
                .field(.ColorVariant.hex, .string, .required)
                .field(.ColorVariant.image, .string, .required)
                .field(.createdAt, .date)
                .field(.updatedAt, .date)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(ColorVariant.schema).delete()
        }
    }
}

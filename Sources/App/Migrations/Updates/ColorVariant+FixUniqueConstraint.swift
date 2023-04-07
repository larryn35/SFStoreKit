//
//  ColorVariant+FixUniqueConstraint.swift
//  
//
//  Created by Larry Nguyen on 4/6/23.
//

import Fluent

extension ColorVariant {
    struct FixUniqueConstraint: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(ColorVariant.schema)
                .deleteUnique(on: .ColorVariant.color)
                .unique(on: .ColorVariant.color, .ColorVariant.productID)
                .update()
        }

        func revert(on database: Database) async throws {
            try await ColorVariant.query(on: database).all().delete(on: database)

            try await database.schema(ColorVariant.schema)
                .deleteUnique(on: .ColorVariant.color, .ColorVariant.productID)
                .unique(on: .ColorVariant.color)
                .update()
        }
    }
}

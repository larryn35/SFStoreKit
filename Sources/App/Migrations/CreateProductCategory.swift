//
//  CreateProductCategory.swift
//  
//
//  Created by Larry Nguyen on 4/4/23.
//

import Fluent

extension ProductCategory {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(ProductCategory.schema)
                .id()
                .field(.name, .string, .required)
                .unique(on: .name)
                .field(.ProductCategory.percentDiscount, .int)
                .field(.createdAt, .date)
                .field(.updatedAt, .date)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(ProductCategory.schema).delete()
        }
    }
}

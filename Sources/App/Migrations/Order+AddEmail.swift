//
//  Order+AddEmail.swift
//  
//
//  Created by Larry Nguyen on 4/6/23.
//

import Fluent

extension Order {
    struct AddEmail: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(Order.schema)
                .field(.Order.email, .string, .required)
                .update()
        }

        func revert(on database: Database) async throws {
            try await database.schema(Order.schema)
                .deleteField(.Order.email)
                .update()
        }
    }
}

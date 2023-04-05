//
//  CreateOrder.swift
//  
//
//  Created by Larry Nguyen on 4/4/23.
//

import Fluent

extension Order {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(Order.schema)
                .id()
                .field(.Order.customerName, .string, .required)
                .field(.Order.address, .string, .required)
                .field(.Order.city, .string, .required)
                .field(.Order.state, .string, .required)
                .field(.Order.zip, .string, .required)
                .field(.Order.totalPrice, .int, .required)
                .field(.Order.discounts, .int, .required)
                .field(.createdAt, .date)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(Order.schema).delete()
        }
    }
}

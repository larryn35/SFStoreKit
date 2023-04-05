//
//  CreateOrderItem.swift
//  
//
//  Created by Larry Nguyen on 4/4/23.
//

import Fluent

extension OrderItem {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(OrderItem.schema)
                .id()
                .field(.OrderItem.orderID, .uuid, .required)
                .foreignKey(.OrderItem.orderID,
                            references: Order.schema, .id,
                            onDelete: .cascade)
                .field(.name, .string, .required)
                .field(.OrderItem.image, .string, .required)
                .field(.OrderItem.color, .string, .required)
                .field(.OrderItem.size, .string, .required)
                .field(.OrderItem.price, .int, .required)
                .field(.OrderItem.discount, .int, .required)
                .field(.OrderItem.quantity, .int, .required)
                .field(.createdAt, .date)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(OrderItem.schema).delete()
        }
    }
}

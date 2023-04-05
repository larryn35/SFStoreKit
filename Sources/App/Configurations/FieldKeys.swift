//
//  FieldKeys.swift
//  
//
//  Created by Larry Nguyen on 4/4/23.
//

import Fluent

extension FieldKey {
    static let name: FieldKey = "name"
    static let createdAt: FieldKey = "created_at"
    static let updatedAt: FieldKey = "updated_at"

    enum ProductCategory {
        static let percentDiscount: FieldKey = "percent_discount"
    }

    enum Product {
        static let categoryID: FieldKey = "category_id"
        static let description: FieldKey = "description"
        static let price: FieldKey = "price"
        static let sizes: FieldKey = "sizes"
    }

    enum ColorVariant {
        static let productID: FieldKey = "product_id"
        static let color: FieldKey = "color"
        static let hex: FieldKey = "hex"
        static let image: FieldKey = "image"
    }

    enum Order {
        static let customerName: FieldKey = "customer_name"
        static let address: FieldKey = "address"
        static let city: FieldKey = "city"
        static let state: FieldKey = "state"
        static let zip: FieldKey = "zip"
        static let totalPrice: FieldKey = "total_price"
        static let discounts: FieldKey = "discounts"
    }

    enum OrderItem {
        static let orderID: FieldKey = "order_id"
        static let image: FieldKey = "image"
        static let color: FieldKey = "color"
        static let size: FieldKey = "size"
        static let price: FieldKey = "price"
        static let discount: FieldKey = "discount"
        static let quantity: FieldKey = "quantity"
    }
}



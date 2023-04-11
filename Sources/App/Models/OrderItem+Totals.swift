//
//  File.swift
//  
//
//  Created by Larry Nguyen on 4/10/23.
//

import Foundation

extension OrderItem {
    var total: Int {
        quantity * price
    }

    var savings: Int {
        quantity * discount
    }
}

extension Array where Element == OrderItem {
    var total: Int {
        self.reduce(0) { $0 + $1.total }
    }

    var savings: Int {
        self.reduce(0) { $0 + $1.savings }
    }
}

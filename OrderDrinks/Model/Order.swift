//
//  Order.swift
//  OrderDrinks
//
//  Created by 顏禹文 on 2019/07/30.
//  Copyright © 2019 顏禹文. All rights reserved.
//

import UIKit

struct Order: Codable {
    var name: String
    var drink: String
    var size: String
    var sweetness: String
    var ice: String
    var peral: String
}

struct OrderData: Encodable {
    var data: Order
}

class OrderController {
    static let shared = OrderController()
    let sheetdbAPI = "https://sheetdb.io/api/v1/yq7zcgr32smmx"
}

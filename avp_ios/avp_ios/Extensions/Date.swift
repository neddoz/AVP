//
//  Date.swift
//  avp_ios
//
//  Created by kayeli dennis on 14/12/2017.
//  Copyright © 2017 kayeli dennis. All rights reserved.
//

import Foundation

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}

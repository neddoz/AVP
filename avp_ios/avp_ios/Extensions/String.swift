//
//  String.swift
//  avp_ios
//
//  Created by kayeli dennis on 07/12/2017.
//  Copyright © 2017 kayeli dennis. All rights reserved.
//

import Foundation

/// Standard Stirng Extensions
extension String {
    func isAndelaEmail()-> Bool {
        let charSet = CharacterSet(charactersIn: ".@")
        let components = self.components(separatedBy: charSet)
        let domainIndex = components.count - 2
        return components[domainIndex].lowercased() == "andela"
    }
}

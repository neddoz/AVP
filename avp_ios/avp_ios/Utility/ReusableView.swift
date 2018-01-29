//
//  ReusableView.swift
//  avp_ios
//
//  Created by kayeli dennis on 11/12/2017.
//  Copyright © 2017 kayeli dennis. All rights reserved.
//

import UIKit

///    Protocol to allow any UIView to become reusable view
public protocol ReusableView {
    ///    By default, it returns the subclass name
    static var reuseIdentifier: String { get }
}

extension ReusableView{
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

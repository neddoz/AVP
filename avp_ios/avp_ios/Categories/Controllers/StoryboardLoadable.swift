//
//  StoryboardLoadable.swift
//  avp_ios
//
//  Created by kayeli dennis on 09/12/2017.
//  Copyright © 2017 kayeli dennis. All rights reserved.
//

import Foundation

public protocol StoryboardLoadable {
    static var storyboardName: String { get }
    static var storyboardIdentifier: String { get }
}

extension StoryboardLoadable where Self: UIViewController {

    public static var storyboardName: String {
        return String(describing: self)
    }

    public static var storyboardIdentifier: String {
        return String(describing: self)
    }

    public static func instantiate(fromStoryboardNamed name: String? = nil) -> Self {
        let sb = name ?? self.storyboardName
        let storyboard = UIStoryboard(name: sb, bundle: nil)
        return instantiate(fromStoryboard: storyboard)
    }

    public static func instantiate(fromStoryboard storyboard: UIStoryboard) -> Self {
        let identifier = self.storyboardIdentifier
        guard let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else {
            fatalError("Failed to instantiate view controller with identifier=\(identifier) from storyboard \( storyboard )")
        }
        return vc

    }

    public static func initial<T: UIViewController>(fromStoryboardNamed name: String? = nil) -> T {
        let sb = name ?? self.storyboardName
        let storyboard = UIStoryboard(name: sb, bundle: nil)
        return initial(fromStoryboard: storyboard)
    }

    public static func initial<T: UIViewController>(fromStoryboard storyboard: UIStoryboard) -> T {
        guard let vc = storyboard.instantiateInitialViewController() as? T else {
            fatalError("Failed to instantiate initial view controller from storyboard named \( storyboard )")
        }
        return vc
    }
}

extension UINavigationController: StoryboardLoadable {}

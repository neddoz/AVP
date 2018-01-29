//
//  AppDelegate.swift
//  avp_ios
//
//  Created by kayeli dennis on 06/12/2017.
//  Copyright © 2017 kayeli dennis. All rights reserved.
//

import UIKit
import os.log
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
    lazy var viewModel = CategoriesViewModel()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        /// firebase configurations
        var filePath = ""
        #if DEBUG
            os_log("Running App in Firebase Debug Mode")
            if let path = Bundle.main.path(forResource: "GoogleService-Info-Debug", ofType: ".plist"){
                filePath = path
            }
        #else
            os_log("Running App in Firebase Release Mode")
            if let path = Bundle.main.path(forResource: "GoogleService-Info-Release", ofType: ".plist"){
                filePath = path
            }
        #endif

        let options = FirebaseOptions(contentsOfFile: filePath)
        FirebaseApp.configure(options: options ?? FirebaseOptions())
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
}

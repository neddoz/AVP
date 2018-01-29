//
//  SignInViewController.swift
//  avp_ios
//
//  Created by kayeli dennis on 06/12/2017.
//  Copyright © 2017 kayeli dennis. All rights reserved.
//

import UIKit
import Firebase
class SignInViewController: UIViewController, GIDSignInUIDelegate, StoryboardLoadable {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        GIDSignIn.sharedInstance().delegate = self

        GIDSignIn.sharedInstance().uiDelegate = self

        GIDSignIn.sharedInstance().signInSilently()
    }
}
extension SignInViewController: GIDSignInDelegate{

    // MARK: -Google sign In delegate methods
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        /// Incase there is an error on signing in
        if let error = error{

            print(error.localizedDescription)

            return
        }

        let authentication = user.authentication
        if let idToken = authentication?.idToken, let accessToken = authentication?.accessToken{

            let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

            Auth.auth().signIn(with: credentials, completion: { (user, error) in

                if error != nil { return }

                guard let user = user, let email = user.email else { return }

                if !email.isAndelaEmail(){

                    GIDSignIn.sharedInstance().signOut()

                    let loginAction = UIAlertAction(title: AlertTextMessages.oKText, style: .default, handler: { (action) in

                        // Resign In with a valid Andela Email
                        GIDSignIn.sharedInstance().signIn()
                    })

                    let alertController = AlertCoordinator.alert(with: AlertTextMessages.validAndelaEmailMessageText,
                                           title: "Oops!",
                                           actions: [loginAction])

                    self.present(alertController, animated: true, completion: nil)
                }
                // On successful Validation is Andela Email
                let categoriesVC = SignInViewController.initial(fromStoryboardNamed: "Categories")
                self.present(categoriesVC, animated: true, completion: nil)
            })
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    }
}

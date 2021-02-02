//
//  LoginViewController.swift
//  MovieQuotes
//
//  Created by Eric Tu on 1/30/21.
//

import UIKit
import FirebaseAuth
import Rosefire
import GoogleSignIn
class LoginViewController: UIViewController {
    let showListSegueID = "ShowListSegue"
    let REGISTRY_TOKEN = "c029cc1b-f0a4-498e-a810-f2fdc8afa555"
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            print("\(Auth.auth().currentUser?.email) is already signed in")
            self.performSegue(withIdentifier: self.showListSegueID, sender: self)
        }
    }

    @IBAction func pressedRoseFireLogin(_ sender: Any) {
        Rosefire.sharedDelegate().uiDelegate = self // This should be your view controller
        Rosefire.sharedDelegate().signIn(registryToken: REGISTRY_TOKEN) { (err, result) in
          if let err = err {
            print("Rosefire sign in error! \(err)")
            return
          }
          Auth.auth().signIn(withCustomToken: result!.token) { (authResult, error) in
            if let error = error {
              print("Firebase sign in error! \(error)")
              return
            }
            print("Signed in as \(Auth.auth().currentUser?.email)")
            self.performSegue(withIdentifier: self.showListSegueID, sender: self)
          }
        }

    
    }
    @IBAction func pressedRegisterButton(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating a new user for email/password \(error)")
                return
            }
            print("New user is created with email \(authResult?.user.email)")
            self.performSegue(withIdentifier: self.showListSegueID, sender: self)
        }
    }
    
    @IBAction func pressedLoginButton(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating a new user for email/password \(error)")
                return
            }
            print("User is signed in with email \(authResult?.user.email)")
            self.performSegue(withIdentifier: self.showListSegueID, sender: self)
        }
    }
}

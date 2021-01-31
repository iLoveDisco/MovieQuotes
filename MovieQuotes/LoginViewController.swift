//
//  LoginViewController.swift
//  MovieQuotes
//
//  Created by Eric Tu on 1/30/21.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {
    let showListSegueID = "ShowListSegue"
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

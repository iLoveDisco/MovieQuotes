//
//  SideNavViewController.swift
//  MovieQuotes
//
//  Created by Eric Tu on 2/2/21.
//

import UIKit

class SideNavViewController : UIViewController {
    
    
    
    @IBAction func pressedEditProfile(_ sender: Any) {
        
    }
    @IBAction func pressedAllQuotes(_ sender: Any) {
        tableViewController.isShowingAllQuotes = true
        tableViewController.startListening()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func pressedMyQuotes(_ sender: Any) {
        tableViewController.isShowingAllQuotes = false
        tableViewController.startListening()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func pressedDeleteQuotes(_ sender: Any) {
        
    }
    @IBAction func pressedSignOut(_ sender: Any) {
        
    }
    
    var tableViewController : MovieQuotesTableViewController {
        get {
            let navController = presentingViewController as! UINavigationController
            return navController.viewControllers.last as! MovieQuotesTableViewController
        }
    }
}

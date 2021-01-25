//
//  MovieQuoteDetailViewController.swift
//  MovieQuotes
//
//  Created by Eric Tu on 1/20/21.
//

import UIKit
import Firebase

class MovieQuoteDetailViewController: UIViewController {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieQuoteLabel: UILabel!
    
    var movieQuote: MovieQuote?
    var movieQuoteRef: DocumentReference!
    var movieQuoteListener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self,
                                                            action: #selector(showEditDialogue))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movieQuoteListener = movieQuoteRef.addSnapshotListener({(docSnapshot, error) in
            if let error = error {
                print("Error getting movie quote \(error)")
                return
            }
            if !docSnapshot!.exists {
                print("Doc snapshot doesn't exist")
                return
            }
            self.movieQuote = MovieQuote(docSnapshot!)
            self.updateView()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        movieQuoteListener.remove()
    }
    
    @objc func showEditDialogue(){
        let alertController = UIAlertController(title: "Edit a new movie quote",
                                                message: "",
                                                preferredStyle: .alert)
        
        // Configure the alert controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submitAction = UIAlertAction(title: "Edit Quote",
                                         style: .default,
                                         handler: {(action) in
                                            let quoteTextField = alertController.textFields![0]
                                            let movieTextField = alertController.textFields![1]
                                            
                                            self.movieQuoteRef.updateData([
                                                "quote": quoteTextField.text!,
                                                "movie": movieTextField.text!
                                            ])
                                         })
        
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Movie Quote"
        })
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Movie"
        }
        
        present(alertController, animated: true, completion: nil)
    }
    

    
    func updateView() {
        movieTitleLabel.text = movieQuote?.movie
        movieQuoteLabel.text = movieQuote?.quote
    }
}

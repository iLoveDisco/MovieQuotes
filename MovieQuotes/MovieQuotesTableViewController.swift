//
//  MovieQuotesTableViewController.swift
//  MovieQuotes
//
//  Created by Eric Tu on 1/16/21.
//

import UIKit
import Firebase
import FirebaseAuth

class MovieQuotesTableViewController: UITableViewController {
    let movieQuoteCellId = "MovieQuoteCell"
    let detailSegueId = "DetailSegue"
    var movieQuotes = [MovieQuote]()
    var movieQuotesRef: CollectionReference!
    var movieQuoteListener: ListenerRegistration!
    var isShowingAllQuotes = true
    var authListenerHandle : AuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddQuoteDialogue))

        movieQuotesRef = Firestore.firestore().collection("Movie Quotes")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authListenerHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if (Auth.auth().currentUser == nil) {
                self.navigationController?.popViewController(animated: true)
            } else {
                print("You are signed in as \(Auth.auth().currentUser?.email)")
            }
        })
        startListening()
    }
    
    func startListening() {
        if movieQuoteListener != nil {
            movieQuoteListener.remove()
        }
        var query = movieQuotesRef.order(by: "created", descending: true).limit(to: 50)
        
        if (!isShowingAllQuotes) {
            query = query.whereField("author", isEqualTo: Auth.auth().currentUser?.uid)
        }
        
        movieQuoteListener = query.addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.movieQuotes.removeAll()
                querySnapshot.documents.forEach { (docSnapshot) in
                    self.movieQuotes.append(MovieQuote(docSnapshot))
                    
                }
                self.tableView.reloadData()
            } else {
                print("Error, not able to get movie quote")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        movieQuoteListener.remove()
        Auth.auth().removeStateDidChangeListener(authListenerHandle)
    }
    
    @objc func showMenu() {
        let alertController = UIAlertController(title: "Manage your Quotes",
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        // Configure the alert controller
        let createQuoteAction = UIAlertAction(title: "Create Quote",
                                         style: .default,
                                         handler: {(action) in
                                            self.showAddQuoteDialogue()
                                         })
        
        let showMyQuotesAction = UIAlertAction(title: self.isShowingAllQuotes ? "My Quotes" : "All Quotes", style: .default) { (action) in
            self.isShowingAllQuotes = !self.isShowingAllQuotes
            self.startListening()
        }

        let signOutAction = UIAlertAction(title: "Sign Out", style: .default) { (action) in
            do {
                try Auth.auth().signOut()
            } catch {
                print("Error with signing out")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        
        
        alertController.addAction(createQuoteAction)
        alertController.addAction(showMyQuotesAction)
        alertController.addAction(signOutAction)
        alertController.addAction(cancelAction)
        
        

        present(alertController, animated: true, completion: nil)
    }
    
    @objc func showAddQuoteDialogue() {
        let alertController = UIAlertController(title: "Create a new movie quote",
                                                message: "",
                                                preferredStyle: .alert)
        
        // Configure the alert controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submitAction = UIAlertAction(title: "Create Quote",
                                         style: .default,
                                         handler: {(action) in
                                            let quoteTextField = alertController.textFields![0]
                                            let movieTextField = alertController.textFields![1]
                                            
                                            self.movieQuotesRef.addDocument(data: [
                                                "quote": quoteTextField.text!,
                                                "movie": movieTextField.text!,
                                                "created": Timestamp.init(),
                                                "author": Auth.auth().currentUser!.uid
                                            ])
                                            self.tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieQuotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: movieQuoteCellId, for: indexPath)
        
        // Configure the cell
        cell.textLabel?.text = movieQuotes[indexPath.row].quote
        cell.detailTextLabel?.text = movieQuotes[indexPath.row].movie
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let movieQuote = movieQuotes[indexPath.row]
        return Auth.auth().currentUser!.uid == movieQuote.author
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let movieQuoteToDelete = movieQuotes[indexPath.row]
            movieQuotesRef.document(movieQuoteToDelete.id!).delete()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegueId {
            if let indexPath = tableView.indexPathForSelectedRow {
                (segue.destination as! MovieQuoteDetailViewController).movieQuote = movieQuotes[indexPath.row]
                (segue.destination as! MovieQuoteDetailViewController).movieQuoteRef = movieQuotesRef.document(movieQuotes[indexPath.row].id!)
            }
        }
    }
}

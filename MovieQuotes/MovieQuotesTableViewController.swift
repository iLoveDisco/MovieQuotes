//
//  MovieQuotesTableViewController.swift
//  MovieQuotes
//
//  Created by Eric Tu on 1/16/21.
//

import UIKit
import Firebase

class MovieQuotesTableViewController: UITableViewController {
    let movieQuoteCellId = "MovieQuoteCell"
    let detailSegueId = "DetailSegue"
    var movieQuotes = [MovieQuote]()
    var movieQuotesRef: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(showAddQuoteDialogue))
        
        movieQuotesRef = Firestore.firestore().collection("Movie Quotes")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.tableView.reloadData()
        movieQuotesRef.addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.movieQuotes.removeAll()
                querySnapshot.documents.forEach { (docSnapshot) in
                    self.movieQuotes.append(MovieQuote(docSnapshot))
                    self.tableView.reloadData()
                }
            } else {
                print("Error, not able to get movie quote")
            }
        }
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
                                            let newMovieQuote = MovieQuote(quote: quoteTextField.text!,
                                                                           movie: movieTextField.text!)
                                            self.movieQuotes.insert(newMovieQuote, at: 0)
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            movieQuotes.remove(at: indexPath.row)
            tableView.reloadData()
            print("Delete this quote")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegueId {
            if let indexPath = tableView.indexPathForSelectedRow {
                (segue.destination as! MovieQuoteDetailViewController).movieQuote = movieQuotes[indexPath.row]
            }
        }
    }
}

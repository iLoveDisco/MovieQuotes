//
//  MovieQuotesTableViewController.swift
//  MovieQuotes
//
//  Created by Eric Tu on 1/16/21.
//

import UIKit

class MovieQuotesTableViewController: UITableViewController {
    let movieQuoteCellId = "MovieQuoteCell"
    var movieQuotes = [MovieQuote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieQuotes.append(MovieQuote(quote: "It's not about the money, it's about sending a message", movie: "The Dark Knight Rises"))
        movieQuotes.append(MovieQuote(quote: "Now's not a good time to be a Nazi", movie: "Jo Jo Rabbit"))
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
}

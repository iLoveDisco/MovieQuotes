//
//  MovieQuotesTableViewController.swift
//  MovieQuotes
//
//  Created by Eric Tu on 1/16/21.
//

import UIKit

class MovieQuotesTableViewController: UITableViewController {
    let movieQuoteCellId = "MovieQuoteCell"
    var names = ["Eric", "Jun", "James", "Angela"]
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: movieQuoteCellId, for: indexPath)
        
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
}

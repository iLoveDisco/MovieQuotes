//
//  MovieQuotes.swift
//  MovieQuotes
//
//  Created by Eric Tu on 1/17/21.
//

import UIKit
import Firebase

class MovieQuote {
    var quote: String
    var movie: String
    var id: String?
    
    init(quote: String, movie: String) {
        self.quote = quote
        self.movie = movie
    }
    
    init(_ docSnapshot: DocumentSnapshot) {
        self.id = docSnapshot.documentID
        let data = docSnapshot.data()!
        self.quote = data["quote"] as! String
        self.movie = data["movie"] as! String
    }
    
    
}

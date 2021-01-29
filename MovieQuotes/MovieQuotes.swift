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
    var author: String
    
    init(_ docSnapshot: DocumentSnapshot) {
        self.id = docSnapshot.documentID
        let data = docSnapshot.data()!
        self.quote = data["quote"] as! String
        self.movie = data["movie"] as! String
        self.author = data["author"] as! String
    }
    
    
}

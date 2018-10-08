//
//  movie.swift
//  movieDB_app
//
//  Created by Marilyn Florek on 10/5/18.
//  Copyright © 2018 Marilyn Florek. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Movie {
    var title: String
    var overview: String
    var baseURLString: String
    var largeURLString: String
    var release_date: String
    var posterURL: URL?
    var backdropPath: URL?
    
    init(dictionary: [String:Any]) {
        title = dictionary["title"] as? String ?? "No Title"
        overview = dictionary["overview"] as? String ?? "No Description"
        baseURLString = "https://image.tmdb.org/t/p/w500"
        largeURLString = "https://image.tmdb.org/t/p/original"
        release_date = dictionary["release_date"] as? String ?? "No Release date"
        
        if let poster = dictionary["poster_path"] as? String {
            self.posterURL = URL(string: baseURLString + poster)!
        }
        
        if let backdrop = dictionary["backdrop_path"] as? String {
            self.backdropPath = URL(string: largeURLString + backdrop)!
        }
    }
    
    class func movies(dictionaries: [[String: Any]]) -> [Movie] {
        var movies: [Movie] = []
        for dictionary in dictionaries {
            let movie = Movie(dictionary: dictionary)
            movies.append(movie)
        }
        return movies
    }
}

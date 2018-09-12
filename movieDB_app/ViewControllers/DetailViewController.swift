//
//  DetailViewController.swift
//  movieDB_app
//
//  Created by Marilyn Florek on 9/8/18.
//  Copyright © 2018 Marilyn Florek. All rights reserved.
//

import UIKit
//import AlamofireImage

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var movieBackdrop: UIImageView!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOverview: UITextView!
    @IBOutlet weak var movieRelease: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var controller: UIView!
    
    var movie: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Movie Details"
        
        activityIndicator.startAnimating()
        controller.backgroundColor = UIColor.black
        movieOverview.backgroundColor = UIColor.black
        moviePoster.backgroundColor = UIColor.black
        movieBackdrop.backgroundColor = UIColor.black
        setView()
    }
    
    func setView() {
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let release = movie["release_date"] as! String
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        let largeURLString = "https://image.tmdb.org/t/p/original"
        let placeholderImage = UIImage(named: "appicon")!
        
        movieTitle.text = title
        movieOverview.text = overview
        movieRelease.text = release
        
        if let poster = movie["poster_path"] as? String {
            let posterPath = URL(string: baseURLString + poster)!
            moviePoster.af_setImage(
                withURL: posterPath,
                placeholderImage: placeholderImage,
                imageTransition: .crossDissolve(0.2)
            )

        } else {
            moviePoster.image = placeholderImage
        }
        
        if let backdrop = movie["backdrop_path"] as? String {
            let backdropPath = URL(string: largeURLString + backdrop)!
            movieBackdrop.af_setImage(
                withURL: backdropPath,
                placeholderImage: placeholderImage,
                imageTransition: .crossDissolve(0.2)
            )
        } else {
            movieBackdrop.image = placeholderImage
        }
        activityIndicator.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

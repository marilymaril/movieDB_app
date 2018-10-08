//
//  DetailViewController.swift
//  movieDB_app
//
//  Created by Marilyn Florek on 9/8/18.
//  Copyright © 2018 Marilyn Florek. All rights reserved.
//

import UIKit

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
    
    var movie: Movie!
    
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
        let placeholderImage = UIImage(named: "appicon")!
        
        movieTitle.text = movie.title
        movieOverview.text = movie.overview
        movieRelease.text = movie.release_date

        if movie.posterURL != nil {
            moviePoster.af_setImage(
                withURL: movie.posterURL!,
                placeholderImage: placeholderImage,
                imageTransition: .crossDissolve(0.2)
            )
        } else {
            moviePoster.image = placeholderImage
        }
        
        if movie.backdropPath != nil {
            movieBackdrop.af_setImage(
                withURL: movie.backdropPath!,
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

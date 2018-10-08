//
//  TableViewCell.swift
//  movieDB_app
//
//  Created by Marilyn Florek on 9/8/18.
//  Copyright © 2018 Marilyn Florek. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieCell: UITableViewCell {
    @IBOutlet weak var PhotoImageView: UIImageView!
    @IBOutlet weak var movieOverview: UITextView!
    @IBOutlet weak var movieTitle: UILabel!
    
    var movies: [Movie] = []
    
    var movie: Movie! {
        didSet {
            if movie != nil {
                movieOverview.text = movie.overview
                movieTitle.text = movie.title
                
                if movie.posterURL != nil {
                    PhotoImageView.af_setImage(withURL: movie.posterURL!)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        movieOverview.textContainer.maximumNumberOfLines = 6
        movieOverview.textContainer.lineBreakMode = .byTruncatingTail
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        cell.movie = movies[indexPath.row]
        
        return cell
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

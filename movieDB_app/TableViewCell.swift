//
//  TableViewCell.swift
//  movieDB_app
//
//  Created by Marilyn Florek on 9/8/18.
//  Copyright © 2018 Marilyn Florek. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var PhotoImageView: UIImageView!
    @IBOutlet weak var movieOverview: UITextView!
    @IBOutlet weak var movieTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        movieOverview.textContainer.maximumNumberOfLines = 6
        movieOverview.textContainer.lineBreakMode = .byTruncatingTail
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        // Configure YourCustomCell using the outlets that you've defined.
        
        return cell
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

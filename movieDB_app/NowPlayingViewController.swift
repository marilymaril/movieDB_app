//
//  NowPlayingViewController.swift
//  movieDB_app
//
//  Created by Marilyn Florek on 9/5/18.
//  Copyright © 2018 Marilyn Florek. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [[String: Any]] = []
    var index: Int!
    var filteredData: [[String:Any]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        self.filteredData = movies
        self.tableView.isHidden = true
        activityIndicator.startAnimating()
        navigationItem.titleView = searchBar
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        

        getData()
    }
    
    func getData() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data,response,error) in
            if let error = error {
                let alertController = UIAlertController(title: "Network Error", message: error.localizedDescription, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                }
                
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }
                print(error.localizedDescription)
            } else if let data = data {
                self.activityIndicator.stopAnimating()
                self.tableView.isHidden = false
                self.tableView.rowHeight = 200
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                
                let movies = dataDictionary["results"] as! [[String:Any]]
                
                self.movies = movies
                self.filteredData = movies
                
                self.tableView.reloadData()
            }
        }
        
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredData.count > 0 {
            return filteredData.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! TableViewCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.lightGray
        cell.selectedBackgroundView = backgroundView
        
        let movie = filteredData[indexPath.row]
        
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        let placeholderImage = UIImage(named: "appicon")!
        let posterPath: URL
        if let poster = movie["poster_path"] as? String {
            posterPath = URL(string: baseURLString + poster)!
            cell.PhotoImageView.af_setImage(
                withURL: posterPath,
                placeholderImage: placeholderImage,
                imageTransition: .crossDissolve(0.2)
            )
        } else {
            cell.PhotoImageView.image = placeholderImage
        }
        
        cell.movieOverview.text = overview
        cell.movieTitle.text = title
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        let detailViewController = segue.destination as! DetailViewController

        let movie = filteredData[(indexPath?.row)!]
        detailViewController.movie = movie
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        searchBar.isHidden = true
        getData()
        refreshControl.endRefreshing()
        searchBar.isHidden = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? self.movies : movies.filter{ (item: [String:Any]) -> Bool in
            return (item["title"] as! String).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }

        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
//    override func 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

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
    
    var movies: [Movie] = []
    var filteredData: [Movie] = []
    var index: Int!
    
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
        MovieApiManager().nowPlayingMovies { (movies: [Movie]?, error: Error?) in
            if let movies = movies {
                self.activityIndicator.stopAnimating()
                self.tableView.isHidden = false
                self.tableView.rowHeight = 200
                self.movies = movies
                self.filteredData = movies
                self.tableView.reloadData()
            } else {
                let alertController = UIAlertController(title: "Network Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)

                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.getData()
                }

                alertController.addAction(OKAction)

                self.present(alertController, animated: true) {}
                print(error?.localizedDescription as Any)
            }
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.lightGray
        cell.selectedBackgroundView = backgroundView
        
        let movie = filteredData[indexPath.row]
        
        cell.movie = movie

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
        filteredData = searchText.isEmpty ? self.movies : movies.filter{ (item: Movie) -> Bool in
            return (item.title).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }

        tableView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//
//  SuperheroViewController.swift
//  movieDB_app
//
//  Created by Marilyn Florek on 9/12/18.
//  Copyright © 2018 Marilyn Florek. All rights reserved.
//

import UIKit

class SuperheroViewController: UIViewController, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    var movies: [[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Superhero Movies"
        collectionView.backgroundColor = UIColor.black
        
        getData()
        collectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getData() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/363088/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        
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

                self.present(alertController, animated: true) {}
                print(error.localizedDescription)
            } else if let data = data {
        
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                
                let movies = dataDictionary["results"] as! [[String:Any]]
                
                self.movies = movies
                self.collectionView.reloadData()
            }
        }
        
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)
        let detailViewController = segue.destination as! DetailViewController
        
        let movie = movies[(indexPath?.row)!]
        detailViewController.movie = movie
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell

        let movie = self.movies[indexPath.item]

        if let posterPathString = movie["poster_path"] as? String
        {
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            let posterPath = URL(string: baseURLString + posterPathString)!
            cell.posterImageView.af_setImage(withURL: posterPath)
        }

        return cell
    }

}

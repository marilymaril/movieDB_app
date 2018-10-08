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
    var movies: [Movie] = []
    
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
        MovieApiManager().nowPlayingMovies { (movies: [Movie]?, error: Error?) in
            if let movies = movies {
                self.movies = movies
                self.collectionView.reloadData()
            } else {
                let alertController = UIAlertController(title: "Network Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                }
                
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true) {}
                print(error?.localizedDescription as Any)
            }
        }
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

        cell.posterImageView.af_setImage(withURL: movie.posterURL!)

        return cell
    }

}

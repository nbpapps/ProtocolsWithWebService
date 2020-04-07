//
//  MoviesTableViewController.swift
//  ProtocolsWithWebService
//
//  Created by niv ben-porath on 07/04/2020.
//  Copyright © 2020 nbpApps. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController {
    
    let dataProvider = DataProvider()
    var movies = [MovieInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMovies()
    }
    
    func loadMovies() {
        dataProvider.getMoviesForPage(page: 2){ [weak self] (moviesResult : Result<Movie,Error>) in
            guard let self = self else {return}
            switch moviesResult {
            case .success(let movies):
                self.movies = movies.results
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let movie = movies[indexPath.row]
        cell.textLabel?.text = movie.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let movieId = String(movie.id)
        dataProvider.getMoviePage(for: movieId) { (movie : Result<MoviePage,Error>) in
            print(movie)
        }
    }
    
    
    
}

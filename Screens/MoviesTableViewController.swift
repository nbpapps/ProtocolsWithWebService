//
//  MoviesTableViewController.swift
//  ProtocolsWithWebService
//
//  Created by niv ben-porath on 07/04/2020.
//  Copyright © 2020 nbpApps. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController {
    
    let moviesDataProvider : MoviesProviding
    let moviePageDataProvider : MoviePageProviding
    var movies = [MovieInfo]()
    
    init(moviesDataProvider : MoviesProviding,moviePageDataProvider : MoviePageProviding) {
        self.moviesDataProvider = moviesDataProvider
        self.moviePageDataProvider = moviePageDataProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        loadMovies()
    }
    
    func loadMovies() {
        moviesDataProvider.getMovies(forPage: 1) { [weak self](moviesResult : Result<Movie,Error>) in
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
        moviePageDataProvider.getMovie(forId: movieId) { (result) in
            print(result)
        }
    }
    
    
    
}

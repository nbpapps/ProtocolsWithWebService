//
//  DataProvider.swift
//  ProtocolsWithWebService
//
//  Created by niv ben-porath on 05/04/2020.
//  Copyright © 2020 nbpApps. All rights reserved.
//

import Foundation

//MARK: - generic network data provider
//this is the 'main' protocol that a screen (or VM) will ask when they need to get data from the network
protocol DataProviding {
    var networkDataObtainer : NetworkDataObtaining {get}
}

//MARK: - specific data providers
protocol MoviesProviding : DataProviding {
    func getMovies(forPage page : Int,with completion : @escaping (Result<Movie,Error>) -> Void )
}

protocol MoviePageProviding : DataProviding {
    func getMovie(forId movieId : String,with completion : @escaping(Result<MoviePage,Error>) -> Void)
}

//MARK: - Data provider implementation
struct DataProvider : DataProviding {
    var networkDataObtainer: NetworkDataObtaining
    
    init(networkDataObtainer: NetworkDataObtaining) {
        self.networkDataObtainer =  networkDataObtainer
    }
}

//MARK: - specific implementations
//these are the specific methods calls
extension DataProvider : MoviesProviding {
    func getMovies(forPage page: Int, with completion: @escaping (Result<Movie, Error>) -> Void) {
        let moviesEndpoint = Endpoint.popularMovies(atPage: String(page))
        networkDataObtainer.getData(for: moviesEndpoint, with: completion)
    }
}

extension DataProvider : MoviePageProviding {
    func getMovie(forId movieId: String, with completion: @escaping (Result<MoviePage, Error>) -> Void) {
        let moviePageEndpoint = Endpoint.movie(withId: movieId)
        networkDataObtainer.getData(for: moviePageEndpoint, with: completion)
    }
}


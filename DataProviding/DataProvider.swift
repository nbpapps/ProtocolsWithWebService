//
//  DataProvider.swift
//  ProtocolsWithWebService
//
//  Created by niv ben-porath on 05/04/2020.
//  Copyright © 2020 nbpApps. All rights reserved.
//

import Foundation

protocol DataProviding {
    var networkDataObtainer : NetworkDataObtaining {get}
}

protocol MoviesProviding : DataProviding {
    func getMovies(forPage page : Int,with completion : @escaping (Result<Movie,Error>) -> Void )
}

protocol MoviePageProviding : DataProviding {
    func getMovie(forId movieId : String,with completion : @escaping(Result<MoviePage,Error>) -> Void)
}

struct DataProvider : DataProviding {
    var networkDataObtainer: NetworkDataObtaining
    
    init(networkDataObtainer: NetworkDataObtaining) {
        self.networkDataObtainer =  networkDataObtainer
    }
}

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


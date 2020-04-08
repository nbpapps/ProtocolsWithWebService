//
//  DataProvider.swift
//  ProtocolsWithWebService
//
//  Created by niv ben-porath on 05/04/2020.
//  Copyright © 2020 nbpApps. All rights reserved.
//

import Foundation

//protocol dataProviding {
//    <#requirements#>
//}

protocol MoviesProviding {
    var networkDataFlow : NetworkDataFlowProviding {get} 
    func getMovies(forPage page : Int,with completion : @escaping (Result<Movie,Error>) -> Void )
}

struct MoviesProvider : MoviesProviding {
    var networkDataFlow: NetworkDataFlowProviding
    
    init(networkDataFlow: NetworkDataFlowProviding) {
        self.networkDataFlow =  networkDataFlow
    }
    
    func getMovies(forPage page: Int, with completion: @escaping (Result<Movie, Error>) -> Void) {
        let moviesEndpoint = Endpoint.popularMovies(atPage: String(page))
        networkDataFlow.getData(for: moviesEndpoint, with: completion)
    }
}


protocol MoviePageProviding {
    var networkDataFlow : NetworkDataFlowProviding {get}
    func getMovie(forId movieId : String,with completion : @escaping(Result<MoviePage,Error>) -> Void)
}

struct MoviePageProvider : MoviePageProviding {
    var networkDataFlow: NetworkDataFlowProviding
    
    init(networkDataFlow: NetworkDataFlowProviding) {
        self.networkDataFlow =  networkDataFlow
    }
    
    func getMovie(forId movieId: String, with completion: @escaping (Result<MoviePage, Error>) -> Void) {
        let moviePageEndpoint = Endpoint.movie(withId: movieId)
        networkDataFlow.getData(for: moviePageEndpoint, with: completion)
    }
    
    
}

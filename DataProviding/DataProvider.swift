//
//  DataProvider.swift
//  ProtocolsWithWebService
//
//  Created by niv ben-porath on 05/04/2020.
//  Copyright © 2020 nbpApps. All rights reserved.
//

import Foundation

/*
we will have a model type which will have a property that is a URL

struct Movies {
   var url : URL
}

*/

enum NetworkEndPoint {
    case movies
}

extension NetworkEndPoint {
    var url : URL {
        switch self {
        case .movies:
            guard let url = URL(string: "https://api.androidhive.info/json/movies.json") else {
                preconditionFailure("invalid URL")
            }
            return url
        }
    }
}


class DataProvider {
    
    
    //MARK: - starting point for getting the movies. This method is in charge of a flow
    func getMovies<T:Decodable>(with completion : @escaping (Result<[T],Error>) -> Void)  {
        fetchNetworkData(at: NetworkEndPoint.movies.url) {[weak self] (networkData : Result<Data,Error>) in
            guard let self = self else {return}
            switch networkData {
            case .success(let data):
                self.parseNetworkData(data: data) { (parsedData : Result<[T],Error>) in
                    switch parsedData {
                    case .success(let moviesArray):
                        completion(.success(moviesArray))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - get the data form the network
    private func fetchNetworkData(at url : URL, with completion : @escaping (Result<Data,Error>) -> Void) {
        let networkAccess = NetworkAccess(url: url)
        networkAccess.fetchData() {(result) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func parseNetworkData<T:Decodable>(data : Data,with completion : @escaping (Result<[T],Error>) -> Void){
        let jsonParser = JsonParser(data: data)
        let reslut : Result<[T],Error> = jsonParser.decode()
        completion(reslut)
    }
    
}

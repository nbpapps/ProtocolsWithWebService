//
//  NetworkDataFlow.swift
//  ProtocolsWithWebService
//
//  Created by niv ben-porath on 08/04/2020.
//  Copyright © 2020 nbpApps. All rights reserved.
//

import Foundation

protocol NetworkDataObtaining {
    func getData<T:Decodable>(for endPointURLProvider : EndPointURLProviding, with completion :@escaping (Result<T,Error>) -> Void)
}

//This class gets a URL (as an EndPointURLProviding), uses it to make a network call (via the network access class) and than parses it into a model object (this is a common flow in apps,so it is composed here)
class NetworkDataObtainer : NetworkDataObtaining {
    
    init() {}
    
    func getData<T>(for endPointURLProvider: EndPointURLProviding, with completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        fetchNetworkData(at: endPointURLProvider.endPointURL) {[weak self] (networkResult : Result<Data,Error>) in
            guard let self = self else {return}
            switch networkResult {
                
            case .success(let data):
                self.parseNetworkData(data: data) { (parserResult : Result<T,Error>) in
                    DispatchQueue.main.async {
                        switch parserResult {
                        case .success(let items):
                            completion(.success(items))
                        case .failure(let error):
                            completion(.failure(error)) // parser error
                        }
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error)) //network fail
                }
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
    
    //MARK: - parse the data
    private func parseNetworkData<T:Decodable>(data : Data,with completion : @escaping (Result<T,Error>) -> Void){
        let jsonParser = JsonParser(data: data)
        let reslut : Result<T,Error> = jsonParser.decode()
        completion(reslut)
    }
}

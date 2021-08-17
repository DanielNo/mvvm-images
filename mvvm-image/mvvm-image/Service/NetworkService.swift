//
//  NetworkService.swift
//  mvvm-image
//
//  Created by Daniel No on 10/30/17.
//  Copyright © 2017 Daniel No. All rights reserved.
//

import Foundation
import Combine


public class NetworkService{
    enum ApplicationError : Error {
        case statusCode
        case other(Error)
        
        static func map(_ error: Error) -> ApplicationError {
          return (error as? ApplicationError) ?? .other(error)
        }

    }
    
    let urlSession : URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadRevalidatingCacheData
        let session = URLSession(configuration: config)
        return session
    }()
    
    func searchGiphy(query : String, completion: @escaping (GiphySearchResponse?) -> ()){
//        print("searched : \(query)")
        guard let request = try? GiphyRequestRouter.giphySearch(query: query, limit: 25, offset: 0, rating: "g", lang: "en", fmt: "json").asURLRequest() else{
            completion(nil)
            print("nil req")
            return
        }
        let dataTask = urlSession.dataTask(with: request) { d, resp, error in
            if let err = error as NSError?{
                print(err.description)
            }else{
                guard let response = resp as? HTTPURLResponse,let data = d else{
                    return
                }
                
                do {
                    let giphyResponse = try JSONDecoder().decode(GiphySearchResponse.self, from: data)
                    completion(giphyResponse)
                } catch let e {
                    print(e.localizedDescription)
                }

            }
        }
        
        dataTask.resume()

    }
    
    func trendingGiphy(){
//        manager.request(GiphyRequestRouter.giphyTrending(limit: 25, offset: 0, rating: "g", fmt: "json")).responseJSON { (data) in
//            //            print(data)
//        }
        
    }
    
    func combineTest() -> AnyCancellable{
        let url = URL(string: "www.google.com")!
        
        let pub = self.urlSession.dataTaskPublisher(for: url).tryMap { (data: Data, response: URLResponse) -> Data in
            guard let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 200 else{
                throw URLError.serverError
            }
            
            return data
        }.decode(type: GiphySearchResponse.self, decoder: JSONDecoder())
        .sink(receiveCompletion: { print ("Received completion: \($0).") },
              receiveValue: { user in print ("Received user: \(user).")})

        
        return pub
        
    }
    
}

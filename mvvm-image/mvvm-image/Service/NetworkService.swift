//
//  NetworkService.swift
//  mvvm-image
//
//  Created by Daniel No on 10/30/17.
//  Copyright © 2017 Daniel No. All rights reserved.
//

import Foundation



public class NetworkService{
    
    let urlSession : URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadRevalidatingCacheData
        let session = URLSession(configuration: config)
        return session
    }()
    
    func searchGiphy(query : String, completion: @escaping (GiphySearchResponse?) -> ()){
        print("searched : \(query)")
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
    
}

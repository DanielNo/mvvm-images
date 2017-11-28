//
//  NetworkService.swift
//  mvvm-image
//
//  Created by Daniel No on 10/30/17.
//  Copyright © 2017 Daniel No. All rights reserved.
//

import Foundation
import Alamofire



public class NetworkService{
    
    let manager : SessionManager = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringCacheData
        return Alamofire.SessionManager(configuration: config)
    }()
    
    func searchGiphy(query : String, completion: @escaping (GiphySearchResponse?) -> ()){
        print("searched : \(query)")
        manager.request(GiphyRequestRouter.giphySearch(query: query, limit: 25, offset: 0, rating: "g", lang: "en", fmt: "json")).responseJSON { (response) in
            if response.result.isFailure{
                completion(nil)
            }

            if let data = response.data{
                do{
                    let giphyResponse = try JSONDecoder().decode(GiphySearchResponse.self, from: data);                    completion(giphyResponse)
                }catch{
                    completion(nil)
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func trendingGiphy(){
        manager.request(GiphyRequestRouter.giphyTrending(limit: 25, offset: 0, rating: "g", fmt: "json")).responseJSON { (data) in
            //            print(data)
        }
        
    }
    
}

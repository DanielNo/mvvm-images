//
//  GifSearchViewModel.swift
//  mvvm-image
//
//  Created by Daniel No on 10/30/17.
//  Copyright © 2017 Daniel No. All rights reserved.
//

import Foundation
import Alamofire

public class GifSearchViewModel {
    let networkService = NetworkService()
    var giphySearchResponse : GiphySearchResponse?
    
    public func searchGiphy(query : String) -> Void {
        networkService.searchGiphy(query: query) { [unowned self] (response) in
            
            guard let searchResult = response else{
                return
            }
//            print(response)
            self.giphySearchResponse = searchResult
        }
    }
    

    
    
}

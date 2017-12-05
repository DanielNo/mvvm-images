//
//  GifSearchViewModel.swift
//  mvvm-image
//
//  Created by Daniel No on 10/30/17.
//  Copyright © 2017 Daniel No. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift


public class GifSearchViewModel {
    let networkService = NetworkService()
    let giphySearchResults: Variable<[GiphySearchResult]> = Variable([])

    public func searchGiphy(query : String) -> Void {
        networkService.searchGiphy(query: query) { [unowned self] (response) in
            guard let searchResult = response?.data else{
                return
            }
            self.giphySearchResults.value = searchResult
            }
    }
    

    
    
}

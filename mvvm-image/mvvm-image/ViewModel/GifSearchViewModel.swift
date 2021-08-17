/*
 View Model : Expose and format data from the model
 */

import Foundation
import Alamofire
import RxSwift
import Combine


public class GifSearchViewModel {
    let networkService = NetworkService()
    let giphySearchResults: Variable<[GiphySearchResult]> = Variable([])
    @Published var combineSearchResults: [GiphySearchResult] = []

    public func searchGiphyRxSwift(query : String) -> Void {
        networkService.searchGiphy(query: query) { [unowned self] (response) in
            guard let searchResult = response?.data else{
                return
            }
            self.giphySearchResults.value = searchResult
            }
    }
    
    public func searchGiphyCombine(query : String) -> Void {
        networkService.searchGiphy(query: query) { [unowned self] (response) in
            guard let searchResult = response?.data else{
                return
            }
            self.combineSearchResults = searchResult
            }
    }
    
    
    
}

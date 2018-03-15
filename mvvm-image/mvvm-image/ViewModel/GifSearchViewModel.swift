/*
 View Model : Expose and format data from the model
 */

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

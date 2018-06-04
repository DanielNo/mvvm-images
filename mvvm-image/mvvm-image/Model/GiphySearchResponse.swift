/*
 Model : Does not communicate with anybody
 The Viewmodel Owns this(model)
 
 */


import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct GiphySearchResponse : Decodable{
    let data : [GiphySearchResult]?
    let pagination : [String : Int]?
    let meta : Meta?
    
    
}

struct GiphySearchResult : Decodable{
    let type : String
    let id : String
    let slug : String
    let url : String
    let bitly_gif_url : String
    let bitly_url : String
    let embed_url : String
    let username : String
    let source : String
    let rating : String
    let content_url : String
    let source_tld : String
    let source_post_url : String
    let is_sticker : Int
    let import_datetime : String
    let trending_datetime : String
    let images : [String : [String : String]]
}

extension GiphySearchResult : IdentifiableType, Equatable{
    typealias Identity = String
    
    var identity : Identity { return id }
    
    static func ==(lhs: GiphySearchResult, rhs: GiphySearchResult) -> Bool {
        return lhs.id == rhs.id
    }
    
}

struct Meta : Decodable{
    let status : Int
    let msg : String?
    let response_id : String?
}



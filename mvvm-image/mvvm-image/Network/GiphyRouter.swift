//
//  GiphyRouter.swift
//  mvvm-image
//
//  Created by Daniel No on 10/29/17.
//  Copyright © 2017 Daniel No. All rights reserved.
//

import Foundation
import Alamofire

enum GiphyRequestRouter : URLRequestConvertible{
    
    case giphySearch(query : String, limit : Int32, offset : Int32, rating : String, lang : String, fmt : String)
    case giphyTrending(limit : Int32, offset : Int32, rating : String, fmt : String)
    
    var baseUrl : String{
        switch self {
        case .giphySearch:
            return NetworkingConstants.giphyBaseUrl
        case .giphyTrending:
            return NetworkingConstants.giphyBaseUrl
        default:
            return NetworkingConstants.giphyBaseUrl
        }
    }
    
    var method: HTTPMethod
    {
        switch self {
        case .giphySearch:
            return .get
        case .giphyTrending:
            return .get
        }
    }
    
    var path: String
    {
        switch self {
        case .giphySearch:
            return NetworkingConstants.giphyAPISearch
        case .giphyTrending:
            return NetworkingConstants.giphyAPITrending
        }
    }
    
    var query: String{
        switch self {
        case .giphySearch(let query, let limit, let offset, let rating, let lang, let fmt):
            return "q=\(query)&limit=\(limit)&offset=\(offset)&rating=\(rating)&fmt=\(fmt)&api_key=S2ngXt0eQSh59Gmcq1F3qx6fY14cYaqi"
        case .giphyTrending:
            return ""
        default:
            return ""
        }
        
    }
    
    func asURLRequest() throws -> URLRequest
    {
        let urlstr = baseUrl + path + query
        guard let url = try? urlstr.asURL() else{
            throw URLError.invalidURL
        }
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = method.rawValue
//        print(urlstr)
        return urlReq
    }
    
}


enum URLError : Error{
    case invalidURL
    case serverError
}



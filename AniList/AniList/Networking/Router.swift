//
//  Router.swift
//  AniList
//
//  Created by Eduardo Bernal on 9/18/17.
//  Copyright © 2017 EEBR. All rights reserved.
//

import Foundation
import Alamofire

enum seriesType: String {
    case anime = "anime"
    case manga = "manga"
}

enum Router: URLRequestConvertible {
    case grantAuthorization(parameters: Parameters)
    case browseSeries(type: seriesType)
    case serieDetail(serie: Serie)
    case serieCharacters(serie: Serie)
    
    static let baseURLString = "https://anilist.co/api/"
    
    var method: HTTPMethod {
        switch self {
        case .grantAuthorization:
            return .post
        case .browseSeries:
            return .get
        case .serieDetail:
            return .get
        case .serieCharacters:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .grantAuthorization:
            return "auth/access_token"
        case .browseSeries(let type):
            return "browse/\(type)"
        case .serieDetail(let serie):
            return "anime/\(serie.id)"
        case .serieCharacters(let serie):
            return "anime/\(serie.id)/characters"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        if let accessToken = UserDefaults.standard.object(forKey: "access_token") as? String {
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }
        
        switch self {
        case .grantAuthorization(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }
        
        return urlRequest
    }
}

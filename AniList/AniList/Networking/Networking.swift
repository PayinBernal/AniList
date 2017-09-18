//
//  Networking.swift
//  AniList
//
//  Created by Eduardo Bernal on 9/18/17.
//  Copyright © 2017 EEBR. All rights reserved.
//

import Foundation
import Alamofire

class Networking {
    
    let manager: Alamofire.SessionManager
    
    static let sharedInstance = Networking()
    
    fileprivate init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        
        manager = Alamofire.SessionManager(configuration: configuration)
    }
    
    class func requestAuth(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let parameters = ["grant_type": "client_credentials",
                          "client_id": "payinbernal-t53pc",
                          "client_secret": "KuL0spz8m0SeasxqUZEmMeO"]
        sharedInstance.manager.request(Router.grantAuthorization(parameters: parameters)).responseJSON {
            switch $0.result {
            case .success(let value as [String: Any]):
                if let accessToken = value["access_token"] as? String {
                    UserDefaults.standard.set(accessToken, forKey: "access_token")
                    if UserDefaults.standard.synchronize() { success() } else {  }
                }
                break
            case .failure(let error): failure(error); break 
            default: break
            }
        }
    }
    
    class func browseSeries(success: @escaping (SeriesCollection) -> (), failure: @escaping (Error) -> ()) {
        sharedInstance.manager.request(Router.browseSeries(type: .anime)).responseJSON {
            switch $0.result {
            case .success(let value):
                success(Parser.parseSeries(response: value))
                break
            case .failure(let error): failure(error); break }
        }
    }
    
    class func requestSerie(serie: Serie, success: @escaping (SerieDetail)->(), failure: @escaping (Error)->()) {
        sharedInstance.manager.request(Router.serieDetail(serie: serie)).responseJSON {
            switch $0.result {
            case .success(let value):
                success(Parser.parseSerieDetail(response: value))
                break
            case .failure(let error): failure(error); break }
        }
    }
    
    class func requestSerieCharacters(serie: Serie, success: @escaping ([Character]) -> (), failure: @escaping (Error) -> ()) {
        sharedInstance.manager.request(Router.serieCharacters(serie: serie)).responseJSON {
            switch $0.result {
            case .success(let value):
                success(Parser.parseSerieCharacters(response: value))
                break
            case .failure(let error): failure(error); break }
        }
    }

}

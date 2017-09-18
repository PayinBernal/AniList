//
//  Parser.swift
//  AniList
//
//  Created by Eduardo Bernal on 9/18/17.
//  Copyright © 2017 EEBR. All rights reserved.
//

import Foundation

class Parser {
    class func parseSeries(response: Any) -> SeriesCollection {
        var seriesArray = SeriesCollection(series: [Serie]())
        guard let responseArray = response as? [[String: Any]] else { return seriesArray }

        for response in responseArray {
            var serie = Serie()
            if let id = response["id"] as? Int {
                serie.id = id
            }
            if let title = response["title_english"] as? String {
                serie.title = title
            }
            if let image = response["image_url_lge"] as? String {
                serie.image = image
            }
            if let banner = response["image_url_banner"] as? String {
                serie.banner = banner
            }
            if let popularity = response["popularity"] as? Int {
                serie.popularity = popularity
            }
            seriesArray.series.append(serie)
        }
        return seriesArray
    }
    
    class func parseSerieDetail(response: Any) -> SerieDetail {
        var detail = SerieDetail()
        guard let response = response as? [String: Any] else { return detail }

        if let description = response["description"] as? String {
            detail.description = description
        }
        detail.youtubeId = response["youtube_id"] as? String
        if let episodes = response["total_episodes"] as? Int {
            detail.episodes = episodes
        }
        
        return detail
    }
    
    class func parseSerieCharacters(response: Any) -> [Character] {
        var charactersArray = [Character]()
        guard let response = response as? [String: Any],
            let characters = response["characters"] as? [[String: Any]]
        else { return charactersArray }
        
        for character in characters {
            print(character)
            guard let name = character["name_first"] as? String,
                let lastName = character["name_last"] as? String,
                let image = character["image_url_med"] as? String,
                let role = character["role"] as? String
            else { break }
            
            let newCharacter = Character(name: name, lastName: lastName, image: image, role: role)
            charactersArray.append(newCharacter)
        }
        return charactersArray
    }
    
}

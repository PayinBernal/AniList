//
//  Serie.swift
//  AniList
//
//  Created by Eduardo Bernal on 9/18/17.
//  Copyright © 2017 EEBR. All rights reserved.
//

import Foundation

struct Serie {
    var id = Int()
    var title = ""
    var image = ""
    var banner = ""
    var popularity = Int()
}

struct SerieDetail {
    var serie = Serie()
    var description = ""
    var youtubeId: String?
    var episodes = Int()
}

struct SeriesCollection {
    var series: [Serie]
}

extension SeriesCollection : Collection {
    var startIndex: Int { return 0 }
    var endIndex: Int {return series.count}
    
    subscript(idx: Int) -> Serie {
        return series[idx]
    }
    
    func index(after i: Int) -> Int {
        guard i != endIndex else { fatalError("Cannot increment endIndex") }
        return i + 1
    }
}

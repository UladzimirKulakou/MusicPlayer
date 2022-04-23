//
//  SearchResponse.swift
//  MusicPlayer
//
//  Created by Владимир  on 23.04.22.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}
struct Track: Decodable {
    var trackName: String
    var artistName: String
    var collectionName: String?
    var artworkUrl100: String?
    
    
}

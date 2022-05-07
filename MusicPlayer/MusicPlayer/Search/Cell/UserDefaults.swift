//
//  UserDefaults.swift
//  MusicPlayer
//
//  Created by Владимир  on 7.05.22.
//

import Foundation

extension UserDefaults {
    
    static let favouriteTrackKey = "favouriteTrackKey"
    
    func savedTrack() -> [SearchViewModel.Cell] {
        let defaults = UserDefaults.standard
        guard let savedTracks = defaults.object(forKey: UserDefaults.favouriteTrackKey) as? Data else { return [] }
        guard let decodedTracks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTracks) as? [SearchViewModel.Cell] else { return [] }
        return decodedTracks
        
    }
    
}

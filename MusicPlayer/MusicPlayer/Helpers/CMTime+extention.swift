//
//  CMTime+extention.swift
//  MusicPlayer
//
//  Created by Владимир  on 3.05.22.
//

import Foundation
import AVKit

extension CMTime {
    
    func toDisplayString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return ""}
        let totalSecond = Int(CMTimeGetSeconds(self))
        let seconds = totalSecond % 60
        let minutes = totalSecond / 60
        let timeForatString = String(format: "%02d:%02d", minutes, seconds)
        return timeForatString
    }
}

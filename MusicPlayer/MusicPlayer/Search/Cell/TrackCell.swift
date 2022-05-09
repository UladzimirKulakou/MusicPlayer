//
//  TrackCell.swift
//  MusicPlayer
//
//  Created by Владимир  on 1.05.22.
//

import UIKit
import SDWebImage

protocol TrackCellViewModel {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var artistName: String { get }
    var collectionName: String { get }
}

class TrackCell: UITableViewCell {

    static let reuseId = "TrackCell"
    @IBOutlet weak var trackImageView: UIImageView!

    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var addTrackOutlet: UIButton!



    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        trackImageView.image = nil
    }
    var cell: SearchViewModel.Cell?

    func set(viewModel: SearchViewModel.Cell) {

        self.cell = viewModel

        let savedTracks = UserDefaults.standard.savedTrack()
        let hasFafourite = savedTracks.firstIndex(where: {
            $0.trackName == self.cell?.trackName && $0.artistName == self.cell?.artistName
        }) != nil
        if hasFafourite {
            addTrackOutlet.isHidden = true
        } else {
            addTrackOutlet.isHidden = false
        }


        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName

        guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
    }

    @IBAction func addTrackAction(_ sender: Any) {

        let defaults = UserDefaults.standard
        guard let cell = cell else { return }
        addTrackOutlet.isHidden = true

        var listOfTracks = defaults.savedTrack()
        listOfTracks.append(cell)

        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: listOfTracks, requiringSecureCoding: false) {
            print("good")
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }

    @IBAction func showInfoAction(_ sender: Any) {
        let defaults = UserDefaults.standard

        if let savedTrack = defaults.object(forKey: UserDefaults.favouriteTrackKey) as? Data {
            if let decodeTracks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTrack) as? [SearchViewModel.Cell] {
                decodeTracks.map { (track) in
                    print (track.trackName)
                }
            }
        }
    }

}

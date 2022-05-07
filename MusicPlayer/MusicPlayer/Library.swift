//
//  Library.swift
//  MusicPlayer
//
//  Created by Владимир  on 7.05.22.
//

import SwiftUI
import URLImage

struct Library: View {
   @State var tracks = UserDefaults.standard.savedTrack()
    @State private var showingAlert = false
    @State private var track: SearchViewModel.Cell!
    
    var tabBarDelegate: MainTabBarControllerDelegate?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
            GeometryReader { geometry in
                HStack(spacing: 20) {
                    Button(action: {
                        print(" 123")
                    }, label: {
                        Image(systemName: "play.fill")
                            .frame(width: geometry.size.width / 2, height: 50)
                            .accentColor(Color.init(#colorLiteral(red: 0.9843382239, green: 0.1764878929, blue: 0.333322078, alpha: 1)))
                            .background(Color.init(#colorLiteral(red: 0.9763854146, green: 0.9765256047, blue: 0.9920390248, alpha: 1)))
                            .cornerRadius(10)
                        
                    })
                    Button(action: {
                        print(" 12345")
                    }, label: {
                        Image(systemName: "arrow.2.circlepath")
                            .frame(width: geometry.size.width / 2, height: 50)
                            .accentColor(Color.init(#colorLiteral(red: 0.9843382239, green: 0.1764878929, blue: 0.333322078, alpha: 1)))
                            .background(Color.init(#colorLiteral(red: 0.9763854146, green: 0.9765256047, blue: 0.9920390248, alpha: 1)))
                            .cornerRadius(10)
                    })
                }
                
                
            }.padding().frame(height: 50)
            Divider().padding(.leading).padding(.trailing)
        
                List {
                    ForEach(tracks) { track in
                        LibraryCell(cell: track).gesture(LongPressGesture().onEnded({ tracks in print("Pressed")
                            self.track = track
                            self.showingAlert = true
                            
                        }).simultaneously(with: TapGesture().onEnded({ _ in
                            self.track = track
                            self.tabBarDelegate?.maximizeTrackDetailController(viewModel: self.track)
                            
                        })))
                    }.onDelete(perform: delete)
                   
                }.cornerRadius(10)
            }.actionSheet(isPresented: $showingAlert , content: {
                ActionSheet(title: Text("Are You sure wont to delete"), buttons:[ .destructive(Text("Delete"), action: {
                    print("deleted: \(self.track.trackName)")
                    self.delete(track: self.track)
                    
                }), .cancel()
                ])
            })
            .navigationBarTitle("Library")
        }
    }
    func delete(at offsets: IndexSet) {
        tracks.remove(atOffsets: offsets)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.setValue(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
    func delete(track: SearchViewModel.Cell) {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return }
        tracks.remove(at: myIndex)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.setValue(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
    
}
struct LibraryCell: View {
    var cell: SearchViewModel.Cell
    var body: some View {
        HStack {
            URLImage(URL(string: cell.iconUrlString ?? "")!) { image in
                image.resizable().frame(width: 60, height: 60).cornerRadius(5)
            }
            
            
            VStack(alignment: .leading) {
                Text("\(cell.trackName)")
                Text("\(cell.artistName)")
            }
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
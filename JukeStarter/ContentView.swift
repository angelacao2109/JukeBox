import SwiftUI
import AVFoundation
import Combine

class PlayerViewModel: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
}

struct ContentView: View {
    @State private var currentSongTime: TimeInterval = 0
    @State private var totalSongDuration: TimeInterval = 0
    @State private var updateTimer: Timer?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var buttonScale: CGFloat = 1.0
    @ObservedObject var viewModel = PlayerViewModel()
    @State private var shuffle: Bool = false
    @State private var currentSongIndex: Int = 0
    @State private var volume: Float = 0.5
    
    
    
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
    
    
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    
    let songs: [Song] = [
        Song(artist: "Rolling Stones", songTitle: "Paint it Black", artistImage: "stones", soundFile: "stones.m4a"),
        Song(artist: "Chubby Checker", songTitle: "Twist and Shout", artistImage: "chubby", soundFile: "twist.mp3"),
        Song(artist: "The Beatles", songTitle: "Twist and Shout", artistImage: "beatles", soundFile: "twistshout.mp3"),
        Song(artist: "Aerosmith", songTitle: "Walk This Way", artistImage: "aerosmith640", soundFile: "walkthisway.mp3"),
        Song(artist: "ABBA", songTitle: "Dancing Queen", artistImage: "abba", soundFile: "dancingqueen.mp3"),
        Song(artist: "John Lennon", songTitle: "Imagine", artistImage: "Imagine", soundFile: "imagine.mp3"),
        Song(artist: "Dominic Fike", songTitle: "Why", artistImage: "Fike", soundFile: "why.mp3"),
        Song(artist: "Dominic Fike ft. Paul McCartney", songTitle: "Kiss of Venus", artistImage: "Fike2", soundFile: "kiss.mp3"),
        Song(artist: "Vampire Weekend", songTitle: "A-Punk", artistImage: "Vampire Weekend", soundFile: "apunk.mp3"),
        Song(artist: "Mathew Wilder", songTitle: "Break My Stride", artistImage: "Mathew Wilder", soundFile: "break.mp3"),
        
        
    ]
    
    var body: some View {
        VStack {
            Text("Music Player")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            List(songs) { song in
                SongRow(song: song,
                        currentSongTime: $currentSongTime,
                        totalSongDuration: $totalSongDuration,
                        audioPlayer: $audioPlayer,
                        updateTimer: $updateTimer)
            }
            .listStyle(PlainListStyle())
            Spacer()
            
            
            Text("\(formatTime(currentSongTime)) / \(formatTime(totalSongDuration))")
                .font(.footnote)
                .padding(.bottom, 8)
            if totalSongDuration > 0 {
                Slider(value: $currentSongTime, in: 0...totalSongDuration, step: 1.0, onEditingChanged: { editing in
                    if !editing {
                        if let player = audioPlayer {
                            player.currentTime = currentSongTime
                        }
                    }
                })
                .padding(.horizontal)
                .accentColor(Color.blue)
            }
            
            HStack(spacing: 50.0) {
                Button(action: {
                 
                    if currentSongIndex > 0 {
                        currentSongIndex -= 1
                    } else {
                        currentSongIndex = songs.count - 1
                    }
                    playsound(thesong: songs[currentSongIndex].soundFile, audioPlayer: &audioPlayer, currentSongTime: $currentSongTime, totalSongDuration: $totalSongDuration, updateTimer: &updateTimer)
                }) {
                    Image(systemName: "backward.fill")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .padding(20)
                        .background(Color.blue)
                        .cornerRadius(40)
                        .shadow(radius: 10)
                }
                
                
                HStack(spacing: 50.0) {
                    Button(action: {
                        if isPlaying {
                            paws(audioPlayer: audioPlayer, updateTimer: &updateTimer)
                            viewModel.objectWillChange.send()
                        } else if let player = audioPlayer, !player.isPlaying {
                            player.play()
                            updateTimer?.invalidate()
                            let currentAudioPlayer = audioPlayer
                            updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                                if let currentTime = currentAudioPlayer?.currentTime {
                                    currentSongTime = currentTime
                                }
                            }
                        } else {
                            playsound(thesong: songs[0].soundFile, audioPlayer: &audioPlayer, currentSongTime: $currentSongTime, totalSongDuration: $totalSongDuration, updateTimer: &updateTimer)
                        }
                    }) {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)
                            .padding(20)
                            .background(Color.blue)
                            .cornerRadius(40)
                            .shadow(radius: 10)
                    }
                }
                .padding(.bottom, 20)
                
                Button(action: {
                    
                    if currentSongIndex < songs.count - 1 {
                        currentSongIndex += 1
                    } else {
                        currentSongIndex = 0
                    }
                    playsound(thesong: songs[currentSongIndex].soundFile, audioPlayer: &audioPlayer, currentSongTime: $currentSongTime, totalSongDuration: $totalSongDuration, updateTimer: &updateTimer)
                }) {
                    Image(systemName: "forward.fill")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .padding(20)
                        .background(Color.blue)
                        .cornerRadius(40)
                        .shadow(radius: 10)
                }
            }
            .padding(.bottom, 20)
            
        }
    }
}

    
struct SongRow: View {
    let song: Song
    @Binding var currentSongTime: TimeInterval
      @Binding var totalSongDuration: TimeInterval
      @Binding var audioPlayer: AVAudioPlayer?
      @Binding var updateTimer: Timer?
    
    
    var body: some View {
        Button(action: {
                   playsound(thesong: song.soundFile, audioPlayer: &audioPlayer, currentSongTime: $currentSongTime, totalSongDuration: $totalSongDuration, updateTimer: &updateTimer)
               }) {
            HStack {
                Image(song.artistImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(song.artist)
                        .font(.headline)
                    Text(song.songTitle)
                        .font(.subheadline)
                }
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

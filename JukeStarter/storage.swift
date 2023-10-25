import SwiftUI
import AVFoundation

struct Song: Identifiable {
    var id = UUID()
    var artist: String
    var songTitle: String
    var artistImage: String
    var soundFile: String
}




var updateTimer: Timer?

func paws(audioPlayer: AVAudioPlayer?, updateTimer: inout Timer?) {
    audioPlayer?.pause()
    updateTimer?.invalidate()
}




struct PlayerButtonsView: View {
    @Binding var currentSongTime: TimeInterval
    @Binding var totalSongDuration: TimeInterval
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        VStack {
            Button(action: {
                paws(audioPlayer: audioPlayer, updateTimer: &updateTimer)
            }) {
                Text("Pause")
            }

            Button(action: {
                playsound(thesong: "YourDefaultSongHere", audioPlayer: &audioPlayer, currentSongTime: $currentSongTime, totalSongDuration: $totalSongDuration, updateTimer: &updateTimer)
            }) {
                Text("Play")
            }
        }
    }
}

func playsound(thesong: String, audioPlayer: inout AVAudioPlayer?, currentSongTime: Binding<TimeInterval>, totalSongDuration: Binding<TimeInterval>, updateTimer: inout Timer?) {
    
    if let player = audioPlayer {
        player.stop()
        audioPlayer = nil
    }

   
    guard let thepath = Bundle.main.path(forResource: thesong, ofType: nil) else { return }
    let url = URL(fileURLWithPath: thepath)
    do {
        audioPlayer = try AVAudioPlayer(contentsOf: url)
    } catch {
      
        return
    }
    
   
    audioPlayer?.play()
    currentSongTime.wrappedValue = 0
    if let duration = audioPlayer?.duration {
        totalSongDuration.wrappedValue = duration
    }
    updateTimer?.invalidate()
    let currentAudioPlayer = audioPlayer
    updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
        if let currentTime = currentAudioPlayer?.currentTime {
            currentSongTime.wrappedValue = currentTime
        }
    }
}
 

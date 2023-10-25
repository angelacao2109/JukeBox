import XCTest
import AVFoundation
@testable import JukeStarter

class JukeStarterTests: XCTestCase {

    var mockAudioPlayer: AVAudioPlayer?
        var mockTimer: Timer?
        var songIndex: Int = 0
        let songs: [String] = [
            "stones.m4a",
            "twist.mp3",
            "twistshout.mp3",
          
        ]
    override func setUpWithError() throws {
      
    }

    override func tearDownWithError() throws {
       
        mockAudioPlayer = nil
        mockTimer = nil
    }

    func testExample() throws {
       
    }

    func testPerformanceExample() throws {
       
        self.measure {

        }
    }

    func testPlayPauseFunctionality() throws {
       
        playsound(thesong: "stones.m4a",
                  audioPlayer: &mockAudioPlayer,
                  currentSongTime: .constant(0),
                  totalSongDuration: .constant(0),
                  updateTimer: &mockTimer)


        XCTAssertTrue(mockAudioPlayer?.isPlaying ?? false, "Sound should be playing after calling the playsound function.")
        
        paws(audioPlayer: mockAudioPlayer, updateTimer: &mockTimer)

        XCTAssertFalse(mockAudioPlayer?.isPlaying ?? true, "Sound should be paused after calling the paws function.")
    }


    func testPerformanceOfPlaySoundFunction() {
        measure {
            playsound(thesong: "stones.m4a",
                      audioPlayer: &mockAudioPlayer,
                      currentSongTime: .constant(0),
                      totalSongDuration: .constant(0),
                      updateTimer: &mockTimer)
        }
    }
}

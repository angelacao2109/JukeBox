

import XCTest

class JukeStarterUITests: XCTestCase {

    override func setUpWithError() throws {

        continueAfterFailure = false

   
    }

    override func tearDownWithError() throws {

    }

    
    func testExample() throws {
        
        let app = XCUIApplication()
        app.launch()

 
    }

    func testPlayPauseButtons() throws {
        let app = XCUIApplication()
        
      
        let playButton = app.buttons["Play"]
        let pauseButton = app.buttons["Pause"]
        
        
        playButton.tap()
       
        XCTAssertTrue(app.staticTexts["Now Playing"].exists, "Expected 'Now Playing' label to be present after tapping play.")
        
    
        sleep(2)
        
    
        pauseButton.tap()
        
        
        XCTAssertTrue(app.staticTexts["Paused"].exists, "Expected 'Paused' label to be present after tapping pause.")
        

    }

                      
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
         
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

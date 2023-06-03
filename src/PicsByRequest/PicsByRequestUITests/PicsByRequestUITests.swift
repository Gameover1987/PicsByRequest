
import XCTest
@testable import PicsByRequest

final class PicsByRequestUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        
        print("Setup!")
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testExample() throws {
        let app = XCUIApplication()
        
        //SeededDataTask.TestImageData = getImageData()
        
        app.launchArguments += ["UI-TESTING"]
        app.launch()

        let searchField = app.textFields["searchField"]
        XCTAssertTrue(searchField.exists)
        searchField.tap()
        searchField.typeText("preved")
        
        let searchButton = app.buttons["searchButton"]
        XCTAssert(searchButton.exists)
        searchButton.tap()
        
        sleep(2)
        
        let imageView = app.images["imageView"]
        XCTAssertTrue(imageView.exists)
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

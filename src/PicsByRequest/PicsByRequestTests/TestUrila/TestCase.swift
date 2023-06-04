
import Foundation
import XCTest

struct TestCase {
    var sourceMatrix: [[Int]]
    var resultMatrix: [Int]
    
    func assert(with actual: [Int]) {
        XCTAssertTrue(actual == resultMatrix)
    }
}

import XCTest
@testable import PicsByRequest

final class AlgorhytmTests : XCTestCase {
    
    /// Тестируем алгоритм (Задание 1)
    func test_AlgorhytmTest1() {
        // Given
        let testCases = getTestCases()
        
        // When
        for testCase in testCases {
            let matrixProcessor = MatrixDistanceProcessor(by: testCase.sourceMatrix)
            let actual = matrixProcessor.process()
            
            // Then
            testCase.assert(with: actual)
        }
    }
    
    private func getTestCases() -> [TestCase] {
        var testCases = [TestCase]()
        
        /// Матрица из тестового задания
        testCases.append(TestCase(
            sourceMatrix: [
            [1, 0, 1],
            [0, 1, 0],
            [0, 0, 0]
          ], resultMatrix: [0, 1, 0, 1, 0, 1, 2, 1, 2]))
        
        /// Матрица от себя
        testCases.append(TestCase(
            sourceMatrix: [
            [1, 0, 0],
            [0, 0, 0],
            [0, 0, 0]
          ], resultMatrix: [0, 1, 2, 1, 2, 3, 2, 3, 4]))
        
        return testCases
    }
}

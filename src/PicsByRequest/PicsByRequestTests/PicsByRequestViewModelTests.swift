
import XCTest
@testable import PicsByRequest

final class PicsByRequestViewModelTests: XCTestCase {

    // Должен корректно загрузить картинку
    func test_SshouldLoadPicture() {
        
        // Given
        let picsProvider = MockPicsProvider(shouldFail: false)
        let favoriteStorage = MockFavoriteStorage()
        let target = PicsByRequestViewModel(picsProvider: picsProvider, favoriteStorage: favoriteStorage)
        let originalRequest = "test_request"
        target.errorAction = { error in
            XCTFail("WTF?? Picture should loaded correctly!")
        }
        target.pictureLoadedAction = { actualResponse in
            
            // Then
            XCTAssert(actualResponse.text == originalRequest)
            XCTAssert(actualResponse.created == MockPicsProvider.successResponse.created)
            XCTAssert(actualResponse.imageData == MockPicsProvider.successResponse.imageData)
        }
        
        // When
        target.loadPicture(by: "test_request")
    }
    
    // Должен сгенерировать ошибку при загрузке картинки
    func test_ShouldGenerateErrorWhenLoadingPicture() {
        
        // Given
        let picsProvider = MockPicsProvider(shouldFail: true)
        let favoriteStorage = MockFavoriteStorage()
        let target = PicsByRequestViewModel(picsProvider: picsProvider, favoriteStorage: favoriteStorage)
        target.errorAction = { error in
            print(error)
        }
        target.pictureLoadedAction = { actualResponse in
            XCTFail("WTF?? Picture loading should fail!")
        }
        
        // When
        target.loadPicture(by: "something request")
    }
}

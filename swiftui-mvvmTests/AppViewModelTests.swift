@testable import swiftui_mvvm
import Combine
import XCTest

class AppViewModelTests: XCTestCase {
    func test_whenUserIsLoggedIn_showsLoggedArea() throws {
        // sut = subject under test
        let (sut, _) = makeSUT(isLoggedIn: true)
        // Can be done in both ways:
        // let state = try XCTUnwrap(sut.state)
        // XCTAssert(state.isLoggedArea)
        XCTAssert(sut.state?.isLoggedArea == true)
    }
    
    func test_whenUserIsNotLoggedIn_showsLogin() {
        let (sut, _) = makeSUT(isLoggedIn: false)
        
        XCTAssert(sut.state?.isLogin == true)
    }
    
    func test_whenUserLogsIn_showsLoggedArea() {
        let (sut, service) = makeSUT(isLoggedIn: false)
        service.login(email: "", password: "", completion: { _ in })
        
        XCTAssert(sut.state?.isLoggedArea == true)
    }
    
    func test_whenUserLogsOut_showsLogin() {
        let (sut, service) = makeSUT(isLoggedIn: true)
        service.logout()
        
        XCTAssert(sut.state?.isLogin == true)
    }
    
    func test_whenUserIsLoggedInAndUserInfoChanges_stateIsNotUpdated() {
        let (sut, service) = makeSUT(isLoggedIn: true)
        
        var sinkCount = 0
        var cancellable: AnyCancellable? = sut.$state.sink { _ in
            sinkCount += 1
        }
        
        service.user?.name = "Luk"
        
        // sinkCount needs to be 1, as when it starts it is called once, and
        // only increases if it's called again, which should only occur if the
        // value that was emitted is different from the previous value
        XCTAssertEqual(sinkCount, 1)
        
        cancellable = nil
    }
}

// MARK: - Helpers
private extension AppViewModelTests {
    func makeSUT(isLoggedIn: Bool) -> (AppViewModel, FakeSessionService) {
        let sessionService = FakeSessionService(
            user: isLoggedIn
            ? .init(email: "lucas@mail.com", name: "Lucas")
            : nil
        )
        return (AppViewModel(sessionService: sessionService), sessionService)
    }
}

private extension AppViewState {
    var isLogin: Bool {
        guard case .login = self else { return false }
        return true
    }
    
    var isLoggedArea: Bool {
        guard case .loggedArea = self else { return false }
        return true
    }
}

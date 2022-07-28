// Annotation to make private classes internals accessible
@testable import swiftui_mvvm
import XCTest

class LoginTests: XCTestCase {
    private var viewModel: LoginViewModel!
    private var service: LoginServiceMock!
    private var didCallLoginDidSucceed: Bool!
    
    override func setUp() {
        super.setUp()
        service = .init()
        didCallLoginDidSucceed = false
        viewModel = .init(
            initialState: .init(),
            service: service,
            loginDidSucceed: { [weak self] in
                self?.didCallLoginDidSucceed = true
            }
        )
    }
    
    func testDefautlInitialState() {
        XCTAssertEqual(
            viewModel.state,
            LoginViewState(
                email: "",
                password: "",
                isLoggingIn: false,
                isShowingErrorAlert: false
            )
        )
        XCTAssertFalse(viewModel.state.canSubmit)
        XCTAssert(viewModel.state.footerMessage.isEmpty)
    }
    
    func testSuccessfulLoginFlow() {
        viewModel.bindings.email.wrappedValue = "alvesluc@dev.com"
        viewModel.bindings.password.wrappedValue = "123"
        XCTAssert(viewModel.state.canSubmit)
        XCTAssert(viewModel.state.footerMessage.isEmpty)
        
        viewModel.login()
        XCTAssertEqual(
            viewModel.state,
            LoginViewState(
                email: "alvesluc@dev.com",
                password: "123",
                isLoggingIn: true,
                isShowingErrorAlert: false
            )
        )
        XCTAssertFalse(viewModel.state.canSubmit)
        XCTAssertEqual(
            viewModel.state.footerMessage,
            LoginViewState.isLogginInFooter
        )
        XCTAssertEqual(service.lastReceivedEmail, "alvesluc@dev.com")
        XCTAssertEqual(service.lastReceivedPassword, "123")
        
        service.completion?(nil)
        XCTAssert(didCallLoginDidSucceed)
    }
    
    func testUnsuccessfulLoginFlow() {
        viewModel.bindings.email.wrappedValue = "alvesluc@dev.com"
        viewModel.bindings.password.wrappedValue = "123"
        XCTAssert(viewModel.state.canSubmit)
        XCTAssert(viewModel.state.footerMessage.isEmpty)
        
        viewModel.login()
        XCTAssertEqual(
            viewModel.state,
            LoginViewState(
                email: "alvesluc@dev.com",
                password: "123",
                isLoggingIn: true,
                isShowingErrorAlert: false
            )
        )
        XCTAssertFalse(viewModel.state.canSubmit)
        XCTAssertEqual(
            viewModel.state.footerMessage,
            LoginViewState.isLogginInFooter
        )
        XCTAssertEqual(service.lastReceivedEmail, "alvesluc@dev.com")
        XCTAssertEqual(service.lastReceivedPassword, "123")
        
        struct FakeError: Error{}
        service.completion?(FakeError())
        XCTAssertEqual(
            viewModel.state,
            LoginViewState(
                email: "alvesluc@dev.com",
                password: "123",
                isLoggingIn: false,
                isShowingErrorAlert: true
            )
        )
        XCTAssert(viewModel.state.canSubmit)
        XCTAssert(viewModel.state.footerMessage.isEmpty)
    }
}

private final class LoginServiceMock: LoginService {
    var lastReceivedEmail: String?
    var lastReceivedPassword: String?
    var completion: ((Error?) -> Void)?
    
    func login(
        email: String,
        password: String,
        completion: @escaping (Error?) -> Void
    ) {
        lastReceivedEmail = email
        lastReceivedPassword = password
        self.completion = completion
    }
}

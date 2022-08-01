// Annotation to make private classes internals accessible
@testable import swiftui_mvvm
import XCTest

class LoginTests: XCTestCase {
    private var viewModel: LoginViewModel!
    private var service: LoginServiceMock!
    
    override func setUp() {
        super.setUp()
        service = .init()
        viewModel = .init(initialState: .init(), service: service)
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
        viewModel.bindings.email.wrappedValue = "lucas@mail.com"
        viewModel.bindings.password.wrappedValue = "123"
        XCTAssert(viewModel.state.canSubmit)
        XCTAssert(viewModel.state.footerMessage.isEmpty)
        
        viewModel.login()
        XCTAssertEqual(
            viewModel.state,
            LoginViewState(
                email: "lucas@mail.com",
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
        XCTAssertEqual(service.lastReceivedEmail, "lucas@mail.com")
        XCTAssertEqual(service.lastReceivedPassword, "123")
    }
    
    func testUnsuccessfulLoginFlow() {
        viewModel.bindings.email.wrappedValue = "lucas@mail.com"
        viewModel.bindings.password.wrappedValue = "123"
        XCTAssert(viewModel.state.canSubmit)
        XCTAssert(viewModel.state.footerMessage.isEmpty)
        
        viewModel.login()
        XCTAssertEqual(
            viewModel.state,
            LoginViewState(
                email: "lucas@mail.com",
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
        XCTAssertEqual(service.lastReceivedEmail, "lucas@mail.com")
        XCTAssertEqual(service.lastReceivedPassword, "123")
        
        struct FakeError: Error{}
        service.completion?(FakeError())
        XCTAssertEqual(
            viewModel.state,
            LoginViewState(
                email: "lucas@mail.com",
                password: "123",
                isLoggingIn: false,
                isShowingErrorAlert: true
            )
        )
        XCTAssert(viewModel.state.canSubmit)
        XCTAssert(viewModel.state.footerMessage.isEmpty)
    }
    
    func test_showSignUpFlow_createsSignUpViewModel() {
        viewModel.showSignUpFlow()
        XCTAssertNotNil(viewModel.state.signUpViewModel)
    }
    
    func test_signUpBinding_readsValueFromState() {
        viewModel.showSignUpFlow()
        XCTAssertNotNil(viewModel.bindings.signUpViewModel.wrappedValue)
    }
    
    func test_signUpBinding_writesValueToState() {
        viewModel.showSignUpFlow()
        
        viewModel.bindings.signUpViewModel.wrappedValue = nil
        
        XCTAssertNil(viewModel.state.signUpViewModel)
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

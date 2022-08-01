@testable import swiftui_mvvm
import XCTest

class SignUpStateTests: XCTestCase {
    func test_whenEmailIsEmpty_cannotAdvanceToPasswordCreation() {
        XCTAssertFalse(SignUpState(email: "").canAdvanceToPasswordCreation)
    }
    
    func test_whenEmailNotIsEmpty_canAdvanceToPasswordCreation() {
        XCTAssert(SignUpState(email: "x").canAdvanceToPasswordCreation)
    }
    
    func test_whenEmailIsNotValid_cannotFinishSignUp() {
        XCTAssertFalse(SignUpState(email: "").canFinishSignUp)
    }
    
    func test_whenStateIsFinal_canFinishSignUp() {
        XCTAssert(
            SignUpState(
                email: "lucas@mail.com",
                password: "lucas",
                passwordConfirmation: "lucas"
            ).canFinishSignUp
        )
    }
}

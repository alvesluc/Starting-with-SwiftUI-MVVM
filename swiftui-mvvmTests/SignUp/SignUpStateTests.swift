@testable import swiftui_mvvm
import XCTest

class SignUpStateTests: XCTestCase {
    func test_whenEmailIsEmpty_cannotAdvanceToPasswordCreation() {
        XCTAssertFalse(SignUpState(email: "").canAdvanceToPasswordCreation)
    }
    
    func test_whenEmailNotIsEmpty_canAdvanceToPasswordCreation() {
        XCTAssert(
            SignUpState(email: "lucas@mail.com").canAdvanceToPasswordCreation
        )
    }
    
    func test_whenEmailIsNotValid_cannotFinishSignUp() {
        XCTAssertFalse(SignUpState(email: "").canFinishSignUp)
    }
    
    func test_whenEmailIsValidAndPassowordIsInvalid_cannotFinishSignUp() {
        XCTAssertFalse(
            SignUpState(
                email: "lucas@mail.com",
                password: "",
                passwordConfirmation: ""
            ).canFinishSignUp
        )
    }
    
    func test_whenEmailIsValidAndPasswordMatchesConfirmation_canFinishSignUp() {
        XCTAssert(
            SignUpState(
                email: "lucas@mail.com",
                password: "lucas",
                passwordConfirmation: "lucas"
            ).canFinishSignUp
        )
    }
    
    func test_whenPasswordDiffersPasswordConfirmation_cannotFinishSignUp() {
        XCTAssertFalse(
            SignUpState(
                email: "lucas@mail.com",
                password: "lucas",
                passwordConfirmation: "lucas123"
            ).canFinishSignUp
        )
    }
}

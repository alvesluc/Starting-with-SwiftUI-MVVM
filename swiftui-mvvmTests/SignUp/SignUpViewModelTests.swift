@testable import swiftui_mvvm
import XCTest

final class SignUpViewModelTests: XCTestCase {
    func test_emailBinding_readsValueFromState() {
        let sut = makeSUT(state: .init(email: "x"))
        
        XCTAssertEqual(sut.email.wrappedValue, "x")
    }
    
    func test_emailBinding_writesValueToState() {
        let sut = makeSUT(state: .init(email: "x"))
        
        sut.email.wrappedValue = ""
        XCTAssert(sut.state.email.isEmpty)
    }

    func test_isShowingPasswordBinding_readsValueFromState() {
        let sut = makeSUT(state: .init(isShowingPasswordCreation: true))
        
        XCTAssert(sut.isShowingPasswordCreation.wrappedValue)
    }
    
    func test_isShowingPasswordBinding_writesValueToState() {
        let sut = makeSUT(state: .init(isShowingPasswordCreation: true))
        
        sut.isShowingPasswordCreation.wrappedValue = false
        XCTAssertFalse(sut.state.isShowingPasswordCreation)
    }
    
    func test_advanceToPasswordCreation_whenEmailIsValid_updatesState() {
        let sut = makeSUT(state: .init(email: "lucas@mail.com"))

        sut.advanceToPasswordCreation()

        XCTAssert(sut.state.isShowingPasswordCreation)
    }

    func test_advanceToPasswordCreation_whenEmailIsNotValid_doNotUpdateState() {
        let sut = makeSUT(state: .init(email: ""))

        sut.advanceToPasswordCreation()

        XCTAssertFalse(sut.state.isShowingPasswordCreation)
    }
}

private extension SignUpViewModelTests {
    func makeSUT(state: SignUpState) -> SignUpViewModel {
        .init(initialState: state, flowCompleted: {})
    }
}

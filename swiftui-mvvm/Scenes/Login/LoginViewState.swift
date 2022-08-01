import Foundation

struct LoginViewState: Equatable {
    var email = ""
    var password = ""
    var isLoggingIn = false
    var isShowingErrorAlert = false
    var signUpViewModel: SignUpViewModel?
}

// Extension only to detach computed variables from stored variables
extension LoginViewState {
    static let isLogginInFooter = "Loggin in..."
    var canSubmit: Bool { !email.isEmpty && !password.isEmpty && !isLoggingIn}
    // Self with uppercase "S", refers to the type itself, which means that
    // LoginViewState.isLogginInFooter and Self.isLogginInFooter are the same
    var footerMessage: String { isLoggingIn ? Self.isLogginInFooter : "" }
}

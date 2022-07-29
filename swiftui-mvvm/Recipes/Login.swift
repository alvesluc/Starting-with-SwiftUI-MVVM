import SwiftUI

struct LoginView: View {
    @ObservedObject private var model: LoginViewModel
    
    init(model: LoginViewModel) {
        self.model = model
    }
    
    var body: some View {
        Form {
            // Another way to access the email Binding:
            // TextField("E-mail", text: _email.projectedValue)
            Section(footer: formFooter) {
                TextField("E-mail", text: model.bindings.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                SecureField("Password", text: model.bindings.password)
            }
        }
        .navigationBarItems(trailing: submitButton)
        .navigationBarTitle("Identify youself")
        .disabled(model.state.isLoggingIn)
        .alert(isPresented: model.bindings.isShowingErrorAlert) {
            Alert(
                title: Text("Oops! Login failed."),
                message: Text("Please verify your e-mail and password.")
            )
        }
    }
    
    private var submitButton: some View {
        Button(action: model.login) {
            Text("Login")
        }.disabled(!model.state.canSubmit)
    }
    
    private var formFooter: some View {
        Group {
            if model.state.isLoggingIn {
                Text(model.state.footerMessage)
            }
        }
    }
    
}

struct LoginViewState: Equatable {
    var email = ""
    var password = ""
    var isLoggingIn = false
    var isShowingErrorAlert = false
}

// Extension only to detach computed variables from stored variables
extension LoginViewState {
    static let isLogginInFooter = "Loggin in..."
    var canSubmit: Bool { !email.isEmpty && !password.isEmpty && !isLoggingIn}
    // Self with uppercase "S", refers to the type itself, which means that
    // LoginViewState.isLogginInFooter and Self.isLogginInFooter are the same
    var footerMessage: String { isLoggingIn ? Self.isLogginInFooter : "" }
}

protocol LoginService {
    func login(
        email: String,
        password: String,
        completion: @escaping (Error?) -> Void
    )
}

struct EmptyLoginService: LoginService {
    func login(
        email: String,
        password: String,
        completion: @escaping (Error?) -> Void
    ) {}
}

final class LoginViewModel: ObservableObject {
    @Published private(set) var state: LoginViewState
    private let service: LoginService
    
    var bindings: (
        email: Binding<String>,
        password: Binding<String>,
        isShowingErrorAlert: Binding<Bool>
    ) {
        (
            email: Binding(to: \.state.email, on: self),
            password: Binding(to: \.state.password, on: self),
            isShowingErrorAlert: Binding(
                to: \.state.isShowingErrorAlert,
                on: self
            )
        )
    }
    
    init(
        initialState: LoginViewState = .init(),
        service: LoginService
    ) {
        self.service = service
        state = initialState
    }
    
    func login() {
        state.isLoggingIn = true
        service.login(
            email: state.email,
            password: state.password
        ) { [weak self] error in
            if error != nil {
                self?.state.isLoggingIn = false
                self?.state.isShowingErrorAlert = true
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView(
                model: .init(
                    initialState: .init(),
                    service: EmptyLoginService()
                )
            )
        }
    }
}

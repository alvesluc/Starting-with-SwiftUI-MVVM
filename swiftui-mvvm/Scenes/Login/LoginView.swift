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
            Section(header: Text("Don't have an account?")) {
                Button(action: model.showSignUpFlow) {
                    Text("Register")
                }
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
        .sheet(item: model.bindings.signUpViewModel) { viewModel in
            NavigationView {
                SignUpView(viewModel: viewModel)
            }
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

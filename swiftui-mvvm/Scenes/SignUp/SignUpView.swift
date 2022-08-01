import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: SignUpViewModel
    
    var body: some View {
        emailCreationView
            .overlay(
                NavigationLink(
                    destination: passwordCreationView,
                    isActive: viewModel.isShowingPasswordCreation,
                    label: EmptyView.init
                )
            )
    }
    
    private var emailCreationView: some View {
        Form {
            Section(header: Text("Insert your best e-mail")) {
                TextField("E-mail", text: viewModel.email)
            }
        }
        .navigationTitle("Email")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                advanceButton
            }
        }
    }
    
    private var passwordCreationView: some View {
        Form {
            Section(header: Text("Create your password")) {
                SecureField("Password", text: viewModel.password)
                SecureField(
                    "Confirm your password",
                    text: viewModel.passwordConfirmation
                )
            }
        }
        .navigationTitle("Password")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                finishButton
            }
        }
    }
    
    private var advanceButton: some View {
        Button(action: viewModel.advanceToPasswordCreation) {
            Text("Next")
        }
        .disabled(!viewModel.state.canAdvanceToPasswordCreation)
    }
    
    private var finishButton: some View {
        Button(action: viewModel.finishSignUp) {
            Text("Finish")
        }
        .disabled(!viewModel.state.canFinishSignUp)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpView(viewModel: .init(
                initialState: .init(
                    email: "lucas@mail.com",
                    isShowingPasswordCreation: true,
                    password: "",
                    passwordConfirmation: ""),
                    flowCompleted: {}
                )
            )
        }
    }
}

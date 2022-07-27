//
//  Login.swift
//  swiftui-mvvm
//
//  Created by Lucas Alves on 19/07/22.
//  Following Cícero Camargo video tutorials:
//  002 SwiftUI + MVVM: Bindings - Parte 1
//  003 SwiftUI + MVVM: Bindings - Parte 2
//

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

struct LoginViewState {
    var email = ""
    var password = ""
    var isLoggingIn = false
    var isShowingErrorAlert = false
}

// Extension only to detach computed variables from stored variables
extension LoginViewState {
    var canSubmit: Bool { !email.isEmpty && !password.isEmpty}
    var footerMessage: String { isLoggingIn ? "Loggin in..." : "" }
}

final class LoginViewModel: ObservableObject {
    @Published private(set) var state: LoginViewState
    
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
    
    init(initialState: LoginViewState) {
        state = initialState
    }
    
    func login() {
        state.isLoggingIn = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.state.isLoggingIn = false
            self.state.isShowingErrorAlert = true
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView(model: .init(initialState: .init()))
        }
    }
}

//
//  Login.swift
//  swiftui-mvvm
//
//  Created by Lucas Alves on 19/07/22.
//  Following Cícero Camargo, 002 SwiftUI + MVVM: Bindings, video tutorial.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggingIn = false
    @State private var isShowingErrorAlert = false
    
    var body: some View {
        Form {
            // Another way to access the email Binding, from the @State wrapper docs:
            // TextField("E-mail", text: _email.projectedValue)
            Section(footer: formFooter) {
                TextField("E-mail", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                SecureField("Password", text: $password)
            }
            
            // Another, with more in depth explanation in the video, way to implement
            // a Binding that can be used in the TextField
            //    private var emailBinding: Binding<String> {
            //        Binding(get: {self.email}, set: {value in self.email = value})
            //    }
        }
        .navigationBarItems(trailing: submitButton)
        .navigationBarTitle("Identify youself")
        .disabled(isLoggingIn)
        .alert(isPresented: $isShowingErrorAlert) {
            Alert(
                title: Text("Oops! Login failed."),
                message: Text("Please verify your e-mail and password.")
            )
        }
    }
    
    private var submitButton: some View {
        Button(action: login) {
            Text("Login")
        }.disabled(email.isEmpty || password.isEmpty)
    }
    
    private var formFooter: some View {
        Group {
            if isLoggingIn {
                Text("Logging in...")
            }
        }
    }
    
    private func login() {
        isLoggingIn = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            isLoggingIn = false
            isShowingErrorAlert = true
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
}

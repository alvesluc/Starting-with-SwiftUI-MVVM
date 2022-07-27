//
//  swiftui_mvvmApp.swift
//  swiftui-mvvm
//
//  Created by Lucas Alves on 18/07/22.
//

import SwiftUI

struct FailWithDelayLoginService: LoginService {
    func login(
        email: String,
        password: String,
        completion: @escaping (Error?) -> Void
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            completion(NSError(domain: "", code: 1, userInfo: nil))
        }
    }
}

@main
struct swiftui_mvvmApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LoginView(
                    model: .init(
                        initialState: .init(),
                        service: FailWithDelayLoginService(),
                        loginDidSucceed: {}
                    )
                )
            }
        }
    }
}

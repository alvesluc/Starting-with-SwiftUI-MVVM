import Foundation

enum AppViewState {
    case login(LoginViewModel)
    case loggedArea(SessionService)
}

import SwiftUI

struct AppView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        switchView()
    }
    
    @ViewBuilder
    func switchView() -> some View {
        switch viewModel.state {
        case let .login(ViewModel):
            NavigationView {
                LoginView(model: ViewModel)
            }
        case let .loggedArea(sessionService):
            VStack {
                Text("Welcome user!")
                Button(
                    action: sessionService.logout,
                    label: {
                        Text("Log out")
                    }
                )
            }
        case .none:
            EmptyView()
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(
            viewModel: .init(
                sessionService: FakeSessionService(user: nil)
            )
        )
    }
}

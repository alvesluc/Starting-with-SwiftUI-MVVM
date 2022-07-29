import Foundation
import Combine

final class AppViewModel: ObservableObject {
    @Published private(set) var state: AppViewState?
    private var userCancellable: AnyCancellable?
    
    init(sessionService: SessionService) {
        userCancellable = sessionService.userPublisher
            // If an User is returned, the map returns true, else, false
            .map { $0 != nil }
            // If it returns true, and it was already true, the removeDuplicates
            // don't let the sink notify the listeners, guaranteeing that the UI
            // isn't rebuilt
            .removeDuplicates()
            .sink { [weak self] isLoggedIn in
                self?.state = isLoggedIn
                    ? .loggedArea(sessionService)
                    : .login(LoginViewModel(service: sessionService))
        }
    }
}

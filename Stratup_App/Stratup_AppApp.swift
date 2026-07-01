import SwiftUI

@main
struct Stratup_AppApp: App {

    @State private var store = ProfileStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
        }
    }
}

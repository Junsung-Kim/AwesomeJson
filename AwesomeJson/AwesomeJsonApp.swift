import SwiftUI

@main
struct AwesomeJsonApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // macOS용 AppDelegate 추가
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // 전체 앱에 대해 스마트 인용부호 및 대시 비활성화
                    UserDefaults.standard.set(false, forKey: "NSAutomaticQuoteSubstitutionEnabled")
                    UserDefaults.standard.set(false, forKey: "NSAutomaticDashSubstitutionEnabled")
                    UserDefaults.standard.synchronize()
                }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // 전체 앱에 대해 스마트 인용부호 및 대시 비활성화 (UserDefaults 설정)
        UserDefaults.standard.set(false, forKey: "NSAutomaticQuoteSubstitutionEnabled")
        UserDefaults.standard.set(false, forKey: "NSAutomaticDashSubstitutionEnabled")
        UserDefaults.standard.synchronize()
    }
}

//
//  DailyApp.swift
//  Daily
//
//  Created by 陳胤亮 on 2025/7/6.
//

import SwiftUI

@main
struct DailyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var auth = AuthService()

    var body: some Scene {
        WindowGroup {
            if auth.user == nil {
                NavigationStack {
                    LoginView()
                }
                .environmentObject(auth)
            } else {
                HomeView()
                    .environmentObject(auth)
            }
        }
    }
}

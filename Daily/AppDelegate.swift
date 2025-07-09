//
//  AppDelegate.swift
//  Daily
//
//  Created by 陳胤亮 on 2025/7/6.
//

import Foundation
import UIKit
import Firebase
import UserNotifications
import BackgroundTasks

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        registerBackgroundTask()
        requestNotificationPermissions()
        scheduleDailyNotification()
        return true
    }

    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    print("Notification permission granted")
                } else {
                    print("Notification permission denied: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
    }
    
    private func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Daily Goals Review"
        content.body = "Time to check your daily progress!"
        content.sound = .default
        
        // Schedule for 23:59 every day
        var dateComponents = DateComponents()
        dateComponents.hour = 23
        dateComponents.minute = 59
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily-reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule daily notification: \(error)")
            } else {
                print("Daily notification scheduled successfully")
            }
        }
    }

    private func registerBackgroundTask() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "daily.summary",
            using: nil) { task in
                Task { await DailyReviewWorker().run(task: task as! BGAppRefreshTask) }
            }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleBackgroundTask()
    }
    
    private func scheduleBackgroundTask() {
        let request = BGAppRefreshTaskRequest(identifier: "daily.summary")
        
        // Schedule for 23:59 today
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.hour = 23
        components.minute = 58
        components.second = 0
        
        if let targetDate = calendar.date(from: components) {
            request.earliestBeginDate = targetDate
        }
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Background task scheduled for daily summary")
        } catch {
            print("Failed to schedule background task: \(error)")
        }
    }
}

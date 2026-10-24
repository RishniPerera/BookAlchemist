//
//  NotificationService.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-24.
//

import UserNotifications
import Foundation

class NotificationService {
    static let shared = NotificationService()
    
    // Ask the user for permission to send notifications
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    // Schedule a daily reading reminder
    func scheduleReadingReminder(hour: Int, minute: Int) {
        // Remove any existing reminders first
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Time to Read!"
        content.body = "Keep your streak alive. Read for at least 15 minutes today."
        content.sound = .default
        
        // Set up the time
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        // Trigger daily
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Create the request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Daily reading reminder scheduled for \(hour):\(minute)")
            }
        }
    }
    
    // A notification for testing (triggers in 2 minutes)
        func scheduleVivaTestNotification() {
            let content = UNMutableNotificationContent()
            content.title = "Notification from BookAlchemist"
            content.body = "You have a new reading challenge TODAY!"
            content.sound = .default
            
            // 120 seconds = 2 minutes
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 120, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling viva notification: \(error)")
                } else {
                    print("Viva test notification scheduled for 2 minutes from now.")
                }
            }
        }
    }

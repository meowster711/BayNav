//
//  notif.swift
//  BayNav
//
//  Created by Genevieve Ngo on 2/16/25.
//
import UIKit
import Foundation

func triggerNotification(dest: bLocation) {
    let content = UNMutableNotificationContent()
    content.title = "Close to " + dest.name
    content.body = "If your destination is " + dest.name + " please select this notification."
    content.sound = .default
    // Encode the destination to Data
        if let encodedData = try? JSONEncoder().encode(dest) {
            content.userInfo = ["destination": encodedData] // Store the encoded data
        }
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    let request = UNNotificationRequest(identifier: "destinationNotification", content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error showing notification: \(error.localizedDescription)")
        }
    }
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        // Extract the encoded data from userInfo
               if let encodedData = userInfo["destination"] as? Data {
                   // Decode the destination
                   if let dest = try? JSONDecoder().decode(bLocation.self, from: encodedData) {
                       if dest.id != 0 {
                           // Navigate to the destination view
                           navigateToDestination(dest: dest)
                       }
                   }
               }
        completionHandler() // must call to end notif processing
    }

    func navigateToDestination(dest: bLocation) {
        // Use a shared state or navigation stack to navigate to the destination
        // Example: Update a @Published property in your app's state
        DispatchQueue.main.async {
            // Assuming you have a shared AppState or similar
            AppState.shared.selectedDestination = dest
        }
    }
}


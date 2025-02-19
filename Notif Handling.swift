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
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    let request = UNNotificationRequest(identifier: "destinationNotification", content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error showing notification: \(error.localizedDescription)")
        }
    }
}

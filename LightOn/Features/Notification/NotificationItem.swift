//
//  NotificationItem.swift
//  LightOn
//
//  Created by 신정욱 on 5/13/25.
//

protocol NotificationItem: Hashable {
    var notificationType: NotificationCell.NotificationType { get }
    var elapsedTimeText: String { get }
    var descriptionText: String { get }
    var isRead: Bool { get }
}

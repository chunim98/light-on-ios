//
//  TestNotificationItem.swift
//  LightOn
//
//  Created by 신정욱 on 5/13/25.
//

struct TestNotificationItem: NotificationItem {
    let notificationType: NotificationCell.NotificationType
    let elapsedTimeText: String
    let descriptionText: String
    var isRead: Bool = false
    
    static let mockItems: [TestNotificationItem] = [
        .init(
            notificationType: .notice,
            elapsedTimeText: "40분 전",
            descriptionText: "라이트온이 새롭게 개편되었어요"
        ),
        .init(
            notificationType: .event,
            elapsedTimeText: "23분 전",
            descriptionText: "라이트온 공연이 곧 시작됩니다. 한 줄일 경우 이렇게 표기됩니다."
        ),
        .init(
            notificationType: .performance,
            elapsedTimeText: "10분 전",
            descriptionText: "홍대 버스킹 무대가 곧 오픈돼요. 자리를 서둘러 주세요!"
        ),
        .init(
            notificationType: .event,
            elapsedTimeText: "1시간 전",
            descriptionText: "서울숲에서 진행되는 특별 이벤트를 놓치지 마세요!"
        ),
        .init(
            notificationType: .notice,
            elapsedTimeText: "2시간 전",
            descriptionText: "프로필 설정 기능이 추가되었어요. 지금 나만의 공연 취향을 등록해보세요!"
        )
    ]
}

//
//  RegisterConcertInfo.swift
//  LightOn
//
//  Created by 신정욱 on 7/15/25.
//

struct RegisterConcertInfo {
    var name: String?              // 공연명
    var description: String?       // 공연 소개
    var regionID: Int?             // 지역 코드
    var detailAddress: String?     // 공연 장소
    var notice: String?            // 선택 - 입장 시 유의사항
    var genre: [String] = []       // 장르
    var posterPath: String?        // 선택 - 포스터 URL

    var startDate: String?         // yyyy-MM-dd
    var endDate: String?           // yyyy-MM-dd
    var startTime: String?         // HH:mm
    var endTime: String?           // HH:mm

    var isPaid: Bool?              // false - 무료, true - 유료
    var price: Int?                // 유료일 때만 필수
    var account: String?           // 유료일 때만 필수
    var bank: String?              // 유료일 때만 필수
    var accountHolder: String?     // 유료일 때만 필수

    var artists: [Int]?            // 같이 공연하는 아티스트 ID (선택)
    var seatType: [String] = []    // 좌석 유형 (STANDING, FREESTYLE, ASSIGNED)
    var documentPath: String?      // 공연 진행 증빙자료 S3 URL
}

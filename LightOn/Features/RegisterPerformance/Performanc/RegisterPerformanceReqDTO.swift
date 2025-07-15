//
//  RegisterPerformanceReqDTO.swift
//  LightOn
//
//  Created by 신정욱 on 7/15/25.
//


struct RegisterPerformanceReqDTO: Encodable {
    
    struct Info: Encodable {
        let title: String               // 공연명
        let description: String         // 공연 소개
        let location: Int               // 지역 코드
        let place: String               // 공연 장소
        let notice: String?             // 선택 - 입장 시 유의사항
        let genre: [String]             // 장르
        let poster: String?             // 선택 - 포스터 URL
    }
    
    struct Schedule: Encodable {
        let startDate: String           // yyyy-MM-dd
        let endDate: String             // yyyy-MM-dd
        let startTime: String           // HH:mm
        let endTime: String             // HH:mm
    }
    
    struct Payment: Encodable {
        let isPaid: Bool                // false - 무료, true - 유료
        let price: Int?                 // 유료일 때만 필수
        let account: String?            // 유료일 때만 필수
        let bank: String?               // 유료일 때만 필수
        let accountHolder: String?      // 유료일 때만 필수
    }
    
    let info: Info
    let schedule: Schedule
    let payment: Payment
    let artists: [Int]?                // 같이 공연하는 아티스트 ID (선택)
    let seat: [String]                 // 좌석 유형 (STANDING, FREESTYLE, ASSIGNED)
    let proof: String                  // 공연 진행 증빙자료 S3 URL
}
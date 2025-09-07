//
//  ConcertInfo.swift
//  LightOn
//
//  Created by 신정욱 on 7/15/25.
//

import Foundation

struct ConcertInfo {
    var title: String?              // 공연명
    var description: String?        // 공연 소개
    var regionID: Int?              // 지역 코드
    var place: String?              // 공연 장소
    var notice: String?             // 선택 - 입장 시 유의사항
    var genre: [String] = []        // 장르
    
    var startDate: String?          // yyyy-MM-dd
    var endDate: String?            // yyyy-MM-dd
    var startTime: String?          // HH:mm
    var endTime: String?            // HH:mm
    
    var isPaid: Bool = false        // false - 무료, true - 유료
    var price: Int?                 // 유료일 때만 필수
    var account: String?            // 유료일 때만 필수
    var bank: String?               // 유료일 때만 필수
    var accountHolder: String?      // 유료일 때만 필수
    
    var isStanding: Bool = false
    var isFreestyle: Bool = false
    var isAssigned: Bool = false
    var totalSeatsCount: Int?
    var artistName: String?
    var artistDescription: String?
    
    /// 포스터 이미지 정보
    var posterInfo: ImageInfo?
    /// 증빙서류 이미지 정보
    var documentInfo: ImageInfo?
}

extension ConcertInfo {
    /// 모든 필수 옵셔널 값이 nil이 아닌지 여부
    var allValuesValid: Bool {
        title != nil &&
        description != nil &&
        regionID != nil &&
        place != nil &&
        notice != nil &&
        !genre.isEmpty && // 장르 배열이 비었을 때, nil로 취급
        startDate != nil &&
        endDate != nil &&
        startTime != nil &&
        endTime != nil &&
        /// 유료 공연일 때만 가격, 계좌, 은행, 예금주 필수
        {
            isPaid
            ? price != nil &&
            account != nil &&
            bank != nil &&
            accountHolder != nil
            : true
        }() &&
        /// 좌석 타입을 하나라도 선택해야 함
        (isStanding || isFreestyle || isAssigned) &&
        totalSeatsCount != nil &&
        artistName != nil &&
        artistDescription != nil &&
        posterInfo != nil &&
        documentInfo != nil
    }
}

//
//  RegisterConcertReqDTO.swift
//  LightOn
//
//  Created by 신정욱 on 7/15/25.
//

import Foundation

struct RegisterConcertReqDTO: Encodable {
    let info: Info
    let schedule: Schedule
    let payment: Payment
    let seat: [SeatType]                // 좌석 유형 (STANDING, FREESTYLE, ASSIGNED)
    let totalSeatsCount: Int
    let artistName: String
    let artistDescription: String
    
    struct Info: Encodable {
        let title: String               // 공연명
        let description: String         // 공연 소개
        let location: Int               // 지역 코드
        let place: String               // 공연 장소
        let notice: String?             // 선택 - 입장 시 유의사항
        let genre: [String]             // 장르
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
    
    enum SeatType: String, Encodable {
        case standing = "STANDING"
        case freestyle = "FREESTYLE"
        case assigned = "ASSIGNED"
    }
}

// MARK: Mapper

extension RegisterConcertReqDTO {
    init?(from domain: RegisterConcertInfo) {
        guard let info = Info(from: domain),
              let schedule = Schedule(from: domain),
              let payment = Payment(from: domain),
              let totalSeatsCount = domain.totalSeatsCount,
              let artistName = domain.artistName,
              let artistDescription = domain.artistDescription
        else { return nil }
        
        self.info = info
        self.schedule = schedule
        self.payment = payment
        self.seat = domain.seatTypes.map { SeatType(from: $0) }
        self.totalSeatsCount = totalSeatsCount
        self.artistName = artistName
        self.artistDescription = artistDescription
    }
}

extension RegisterConcertReqDTO.Info {
    init?(from domain: RegisterConcertInfo) {
        guard let title = domain.title,
              let description = domain.description,
              let location = domain.regionID,
              let place = domain.place
        else { return nil }
        
        self.title = title
        self.description = description
        self.location = location
        self.place = place
        self.notice = domain.notice
        self.genre = domain.genre
    }
}

extension RegisterConcertReqDTO.Schedule {
    init?(from domain: RegisterConcertInfo) {
        guard let startDate = domain.startDate,
              let endDate = domain.endDate,
              let startTime = domain.startTime,
              let endTime = domain.endTime
        else { return nil }
        
        self.startDate = startDate
        self.endDate = endDate
        self.startTime = startTime
        self.endTime = endTime
    }
}

extension RegisterConcertReqDTO.Payment {
    init?(from domain: RegisterConcertInfo) {
        self.isPaid = domain.isPaid
        self.price = domain.isPaid ? domain.price : nil
        self.account = domain.isPaid ? domain.account : nil
        self.bank = domain.isPaid ? domain.bank : nil
        self.accountHolder = domain.isPaid ? domain.accountHolder : nil
    }
}

extension RegisterConcertReqDTO.SeatType {
    init(from domain: RegisterConcertInfo.SeatType) {
        switch domain {
        case .standing:     self = .standing
        case .freestyle:    self = .freestyle
        case .assigned:     self = .assigned
        }
    }
}

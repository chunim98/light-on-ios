//
//  RegisterBuskingReqDTO.swift
//  LightOn
//
//  Created by 신정욱 on 7/14/25.
//


struct RegisterBuskingReqDTO: Encodable {
    let info: Info
    let schedule: Schedule
    let artistName: String
    let artistDescription: String
    
    struct Info: Encodable {
        let title: String
        let description: String
        let location: Int
        let place: String
        let notice: String?     // 선택 필드
        let genre: [String]     // 문자열 배열로 수정
    }
    
    struct Schedule: Encodable {
        let startDate: String   // yyyy-MM-dd
        let endDate: String     // yyyy-MM-dd
        let startTime: String   // "HH:mm"
        let endTime: String     // "HH:mm"
    }
}

// MARK: Mapper

extension RegisterBuskingReqDTO {
    init?(from domain: RegisterBuskingInfo) {
        guard let title = domain.name,
              let description = domain.description,
              let location = domain.regionID,
              let place = domain.detailAddress,
              let genres = domain.genre.isEmpty ? nil : domain.genre,
              let startDate = domain.startDate,
              let endDate = domain.endDate,
              let startTime = domain.startTime,
              let endTime = domain.endTime,
              let artistName = domain.artistName,
              let artistDescription = domain.artistDescription
        else { return nil }
        
        self.info = Info(
            title: title,
            description: description,
            location: location,
            place: place,
            notice: domain.notice,
            genre: genres
        )
        self.schedule = Schedule(
            startDate: startDate,
            endDate: endDate,
            startTime: startTime,
            endTime: endTime
        )
        self.artistName = artistName
        self.artistDescription = artistDescription
    }
}

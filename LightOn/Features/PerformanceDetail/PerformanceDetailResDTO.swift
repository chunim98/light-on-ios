//
//  PerformanceDetailResDTO.swift
//  LightOn
//
//  Created by 신정욱 on 7/16/25.
//


struct PerformanceDetailResDTO: Decodable {
    let id: Int
    let info: Info
    let artists: [Artist]
    let genres: [String]
    let schedule: Schedule
    let regionCode: Int
    let regionName: String
    let type: PerformanceType
    let seats: [SeatType]
    let totalSeatsCount: Int
    let bookedSeatCount: Int
    let proofUrl: String
    
    struct Info: Decodable {
        let title: String
        let description: String
        let place: String
        let notice: String
        let posterUrl: String
    }
    
    struct Artist: Decodable {
        let id: Int?
        let name: String
        let description: String
        let activityLocation: Int?
        let genre: [String]?
        let profileImage: String?
    }
    
    struct Schedule: Decodable {
        let startDate: String
        let endDate: String
        let startTime: String  // "HH:mm:ss"
        let endTime: String    // "HH:mm:ss"
    }
    
    enum PerformanceType: String, Decodable {
        case concert = "CONCERT"
        case busking = "BUSKING"
    }
    
    enum SeatType: String, Decodable {
        case standing = "STANDING"
        case freestyle = "FREESTYLE"
        case assigned = "ASSIGNED"
    }
    
    func toDomain() -> PerformanceDetailInfo {
        let type: PerformanceDetailInfo.PerformanceType = {
            switch self.type {
            case .concert: .concert
            case .busking: .busking
            }
        }()
        let date = schedule.startDate.replacingOccurrences(of: "-", with: ".")
        let time = schedule.startTime.prefix(5)
        let seatDescription = seats.reduce("") { "\($0)• \($1.rawValue)\n" }
        
        return PerformanceDetailInfo(
            type: type,
            thumbnailPath: info.posterUrl,
            genre: genres.first ?? "알 수 없는 장르",
            title: info.title,
            date: date,
            time: String(time),
            place: info.place,
            price: "(무료? 유료?) 0000원",
            description: info.description,
            artistName: artists.first?.name ?? "알 수 없는 아티스트",
            artistDescription: artists.first?.description ?? "소개가 없습니다.",
            seatDescription: seatDescription,
            noticeDescription: info.notice
        )
    }
}

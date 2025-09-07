//
//  MyRegisteredResDTO.swift
//  LightOn
//
//  Created by 신정욱 on 8/9/25.
//

struct MyRegisteredResDTO: Decodable {
    let performanceList: [RegisteredPerformance]
    
    struct RegisteredPerformance: Decodable {
        let id: Int
        let title: String
        let startDate: String
        let startTime: String
        let performanceStatus: PerformanceStatus
        let address: String
        let isPaid: Bool
        let createdAt: String
        let isConcert: Bool
    }
    
    enum PerformanceStatus: String, Decodable {
        case pending = "PENDING"
        case approved = "APPROVED"
        case finished = "FINISHED"
        case rejected = "REJECTED"
    }
}

// MARK: Mapper

extension MyRegisteredResDTO.RegisteredPerformance {
    func toDomain() -> MyPerformanceCellItem {
        let date = startDate.replacingOccurrences(of: "-", with: ".")
        let time = startTime.prefix(5)
        
        let style: MyPerformanceCellStyle = {
            switch performanceStatus {
            case .pending:  .registerPending
            case .approved: .registerApproved
            case .finished: .registerFinished
            case .rejected: .registerRejected
            }
        }()
        
        return MyPerformanceCellItem(
            id: id,
            title: title,
            type: isPaid ? "유료공연" : "무료공연",
            date: date,
            time: String(time),
            place: address,
            publishedAt: "등록일 : \(createdAt)",
            isConcert: isConcert,
            style: style
        )
    }
}

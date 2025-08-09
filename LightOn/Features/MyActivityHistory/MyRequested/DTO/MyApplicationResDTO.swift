//
//  MyApplicationResDTO.swift
//  LightOn
//
//  Created by 신정욱 on 8/9/25.
//

struct MyApplicationResDTO: Decodable {
    let performanceList: [RequestedPerformance]
    
    struct RequestedPerformance: Decodable {
        let id: Int
        let title: String
        let startDate: String
        let startTime: String
        let performanceStatus: PerformanceStatus
        let address: String
        let isPaid: Bool
        let requestedAt: String
    }
    
    enum PerformanceStatus: String, Decodable {
        case pending = "PENDING"
        case approved = "APPROVED"
        case finished = "FINISHED"
        case rejected = "REJECTED"
    }
}

// MARK: Mapper

extension MyApplicationResDTO.RequestedPerformance {
    func toDomain() -> MyPerformanceCellItem {
        let date = startDate.replacingOccurrences(of: "-", with: ".")
        let time = startTime.prefix(5)
        
        let style: MyPerformanceCellStyle = {
            switch performanceStatus {
            case .pending:  .requestPending
            case .approved: .requestApproved
            case .finished: .requestFinished
            case .rejected: .requestRejected
            }
        }()
        
        return MyPerformanceCellItem(
            id: id,
            title: title,
            type: isPaid ? "유료공연" : "무료공연",
            date: date,
            time: String(time),
            place: address,
            publishedAt: "신청일 : \(requestedAt)",
            style: style
        )
    }
}

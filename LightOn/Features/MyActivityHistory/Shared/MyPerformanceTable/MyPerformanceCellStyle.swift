//
//  MyPerformanceCellStyle.swift
//  LightOn
//
//  Created by 신정욱 on 8/9/25.
//


import UIKit

struct MyPerformanceCellStyle: Hashable {
    let statusText: String
    let statusForegroundColor: UIColor
    let backgroundColor: UIColor
    
    static var requestPending: MyPerformanceCellStyle {
        MyPerformanceCellStyle(
            statusText: "신청 대기",
            statusForegroundColor: .x6DAF4F,
            backgroundColor: .xECFCE5
        )
    }
    
    static var requestApproved: MyPerformanceCellStyle {
        MyPerformanceCellStyle(
            statusText: "신청 완료",
            statusForegroundColor: .brand,
            backgroundColor: .xF5F0FF
        )
    }
    
    static var requestFinished: MyPerformanceCellStyle {
        MyPerformanceCellStyle(
            statusText: "공연 종료",
            statusForegroundColor: .caption,
            backgroundColor: .background
        )
    }
    
    static var requestRejected: MyPerformanceCellStyle {
        MyPerformanceCellStyle(
            statusText: "신청 거절(디자인 필요)",
            statusForegroundColor: .caption,
            backgroundColor: .background
        )
    }
    
    static var registerPending: MyPerformanceCellStyle {
        MyPerformanceCellStyle(
            statusText: "승인 대기",
            statusForegroundColor: .x6DAF4F,
            backgroundColor: .xECFCE5
        )
    }
    
    static var registerApproved: MyPerformanceCellStyle {
        MyPerformanceCellStyle(
            statusText: "승인 완료",
            statusForegroundColor: .brand,
            backgroundColor: .xF5F0FF
        )
    }
    
    static var registerFinished: MyPerformanceCellStyle {
        MyPerformanceCellStyle(
            statusText: "공연 종료",
            statusForegroundColor: .caption,
            backgroundColor: .background
        )
    }
    
    static var registerRejected: MyPerformanceCellStyle {
        MyPerformanceCellStyle(
            statusText: "승인 거절(디자인 필요)",
            statusForegroundColor: .caption,
            backgroundColor: .background
        )
    }
}

//
//  ValidateBuskingModificationUC.swift
//  LightOn
//
//  Created by 신정욱 on 8/29/25.
//

import Foundation
import Combine

/// 등록한 공연의 편집 및 취소가 가능한지를 판단하는 유즈케이스
/// - 공연 취소: 1시간 전까지 가능
/// - 공연 수정: 3일 전까지는 가능
final class ValidateBuskingModificationUC {
    func validateEditable(
        initialInfo: AnyPublisher<BuskingInfo, Never>,
        currentInfo: AnyPublisher<BuskingInfo, Never>
    ) -> AnyPublisher<Bool, Never> {
        /// 공연 수정이 가능한지 판별
        /// - 3일 전까지는 수정 가능
        let buskingEditable = initialInfo
            .map { info -> Bool in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                guard
                    let startText = info.startDate,
                    let startDate = formatter.date(from: startText)
                else { return false }
                
                let calendar = Calendar.current
                let today = calendar.startOfDay(for: .now)
                let start = calendar.startOfDay(for: startDate)
                
                let days = calendar
                    .dateComponents([.day], from: today, to: start)
                    .day ?? .min
                
                return days >= 3
            }
            .eraseToAnyPublisher()
        
        /// 모든 필드가 유효한지 여부
        let allValuesValid = currentInfo
            .map { $0.allValuesValid }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        /// 공연 시작까지 3일 이상 남아있고 모든 필드가 유효한지 여부 반환
        return Publishers
            .CombineLatest(allValuesValid, buskingEditable)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
    
    /// 공연 취소가 가능한지 판별
    /// - 1시간 전까지는 취소 가능
    func validateCancellable(
        initialInfo: AnyPublisher<BuskingInfo, Never>
    ) -> AnyPublisher<Bool, Never> {
        initialInfo.map { info -> Bool in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            guard
                let startText = info.startDate,
                let startDate = formatter.date(from: startText)
            else { return false }
            
            let now = Date()
            let oneHourBeforeStart = startDate.addingTimeInterval(-3600)
            
            // 시작 1시간 전부터는 false, 그 전에는 true
            return now < oneHourBeforeStart
        }
        .eraseToAnyPublisher()
    }
}

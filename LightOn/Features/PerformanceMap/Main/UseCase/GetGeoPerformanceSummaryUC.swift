//
//  GetGeoPerformanceSummaryUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/22/25.
//

import Combine

final class GetGeoPerformanceSummaryUC {
    /// 선택한 마커 정보로 공연 특정
    func execute(
        selectedID: AnyPublisher<Int?, Never>,
        performances: AnyPublisher<[GeoPerformanceInfo], Never>
    ) -> AnyPublisher<GeoPerformanceInfo?, Never> {
        selectedID
            .withLatestFrom(performances) { selectedID, performances in
                guard let selectedID else { return nil }
                return performances.first { selectedID == $0.id }
            }
            .eraseToAnyPublisher()
    }
}

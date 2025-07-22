//
//  GetMapSummaryUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/22/25.
//

import Combine

final class GetMapSummaryUC {
    /// 선택한 마커 정보로 공연 특정
    func execute(
        selectedMarker: AnyPublisher<MarkerInfo?, Never>,
        performances: AnyPublisher<[PerformanceMapInfo], Never>
    ) -> AnyPublisher<PerformanceMapInfo?, Never> {
        selectedMarker
            .withLatestFrom(performances) { marker, performances in
                guard let marker else { return nil }
                return performances.first { marker.performaceID == $0.performanceID }
            }
            .eraseToAnyPublisher()
    }
}

//
//  MoveCameraUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/22/25.
//

import Combine
import CoreLocation

final class MoveCameraUC {
    /// 카메라를 이동 시킬 좌표 계산
    func execute(
        initialCoord: AnyPublisher<CLLocationCoordinate2D, Never>,
        selectedCell: AnyPublisher<SpotlightedCellItem, Never>,
        performances: AnyPublisher<[GeoPerformanceInfo], Never>
    ) -> AnyPublisher<CLLocationCoordinate2D, Never> {
        /// 선택한 공연의 좌표
        let selectedCellCoord = selectedCell
            .withLatestFrom(performances) { cellItem, performances in
                performances.first { cellItem.performanceID == $0.id }
            }
            .compactMap {
                $0.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
            }
            .eraseToAnyPublisher()
        
        return Publishers
            .Merge(initialCoord, selectedCellCoord)
            .eraseToAnyPublisher()
    }
}

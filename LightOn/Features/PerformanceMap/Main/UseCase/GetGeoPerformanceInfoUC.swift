//
//  GetGeoPerformanceInfoUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/21/25.
//

import Combine
import CoreLocation

final class GetGeoPerformanceInfoUC {
    
    private let repo: GeoPerformanceRepo
    
    init(repo: GeoPerformanceRepo) {
        self.repo = repo
    }
    
    /// 좌표와 반경으로 공연맵 조회
    func execute(
        initialCoord: AnyPublisher<CLLocationCoordinate2D, Never>,
        refreshCoord: AnyPublisher<CLLocationCoordinate2D, Never>
    ) -> AnyPublisher<[GeoPerformanceInfo], Never> {
        // 50000은 임시 반경, 반경 계산하는 로직 필요할 듯
        Publishers.Merge(initialCoord, refreshCoord)
            .compactMap { [weak self] in self?.repo.getGeoPerformanceInfo(coord: $0, radius: 50000) }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}

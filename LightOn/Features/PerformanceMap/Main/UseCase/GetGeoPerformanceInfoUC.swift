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
    
    /// 좌표와 반경, 필터로 공연맵 조회
    func execute(
        initialCoord: AnyPublisher<CLLocationCoordinate2D, Never>,
        refreshCoord: AnyPublisher<CLLocationCoordinate2D, Never>,
        searchedCoord: AnyPublisher<CLLocationCoordinate2D, Never>,
        filterType: AnyPublisher<MapFilterType?, Never>
    ) -> AnyPublisher<[GeoPerformanceInfo], Never> {
        let coord = Publishers.Merge3(initialCoord, refreshCoord, searchedCoord)
        
        return Publishers.CombineLatest(coord, filterType)
            .compactMap { [weak self] coord, filterType in
                // 50000은 임시 반경, 반경 계산하는 로직 필요할 듯?
                if let filterType {
                    self?.repo.getGeoPerformanceInfo(coord: coord, radius: 50000, type: filterType)
                } else {
                    self?.repo.getGeoPerformanceInfo(coord: coord, radius: 50000)
                }
            }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}

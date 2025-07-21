//
//  GetPerformanceMapListUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/21/25.
//

import Combine
import CoreLocation

final class GetPerformanceMapListUC {
    
    private let repo: PerformanceMapRepo
    
    init(repo: PerformanceMapRepo) {
        self.repo = repo
    }
    
    /// 좌표와 반경으로 공연맵 조회
    func execute(
        cameraLocation: AnyPublisher<CLLocationCoordinate2D, Never>
    ) -> AnyPublisher<[PerformanceMapInfo], Never> {
        // 5000은 임시 반경, 반경 계산하는 로직 필요할 듯
        cameraLocation
            .compactMap { [weak self] in self?.repo.getPerformances(coord: $0, radius: 5000) }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}

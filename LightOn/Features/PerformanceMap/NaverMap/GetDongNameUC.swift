//
//  GetDongNameUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/21/25.
//

import Combine
import CoreLocation

final class GetDongNameUC {
    
    private let repo: ReverseGeocodingRepo
    
    init(repo: ReverseGeocodingRepo) {
        self.repo = repo
    }
    
    /// 현재 위치의 동 이름 조회
    func execute(
        cameraLocation: AnyPublisher<CLLocationCoordinate2D, Never>
    ) -> AnyPublisher<String?, Never> {
        cameraLocation
            .compactMap { [weak self] in self?.repo.getDongName(coord: $0) }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}

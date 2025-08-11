//
//  GetGeocodingInfoUC.swift
//  LightOn
//
//  Created by 신정욱 on 8/11/25.
//

import Combine

final class GetGeocodingInfoUC {
    
    private let repo: GeocodingRepo
    
    init(repo: GeocodingRepo) {
        self.repo = repo
    }
    
    /// 주소로 지오코딩 요청(지명 -> 좌표)
    func execute(
        adress: AnyPublisher<String, Never>,
        trigger: AnyPublisher<Void, Never>
    ) -> AnyPublisher<GeocodingInfo?, Never> {
        trigger.withLatestFrom(adress) { _, adress in adress }
            .compactMap { [weak self] in self?.repo.getGeocodingInfo(name: $0) }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}

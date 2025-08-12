//
//  GetGeocodingInfoUC.swift
//  LightOn
//
//  Created by 신정욱 on 8/11/25.
//

import Foundation
import Combine

final class GetGeocodingInfoUC {
    
    private let repo: GeocodingRepo
    
    init(repo: GeocodingRepo) {
        self.repo = repo
    }
    
    /// 주소로 지오코딩 요청(지명 -> 좌표)
    func execute(
        adress: AnyPublisher<String, Never>
    ) -> AnyPublisher<[GeocodingInfo], Never> {
        adress
            .debounce(for: 0.75, scheduler: RunLoop.main)
            .filter { !$0.isEmpty }
            .compactMap { [weak self] in self?.repo.getGeocodingInfo(name: $0) }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}

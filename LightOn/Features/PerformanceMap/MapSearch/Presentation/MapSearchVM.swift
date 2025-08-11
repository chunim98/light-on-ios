//
//  MapSearchVM.swift
//  LightOn
//
//  Created by 신정욱 on 8/11/25.
//

import Foundation
import CoreLocation
import Combine

final class MapSearchVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        /// 검색할 주소
        let address: AnyPublisher<String, Never>
        /// 지오코딩 요청 트리거
        let trigger: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 검색 결과 좌표
        let coord: AnyPublisher<CLLocationCoordinate2D?, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let getGeocodingInfoUC: GetGeocodingInfoUC
    
    // MARK: Initializer
    
    init(repo: any GeocodingRepo) {
        self.getGeocodingInfoUC = .init(repo: repo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        /// 지오코딩 결과
        let geocodingInfo = getGeocodingInfoUC.execute(
            adress: input.address,
            trigger: input.trigger
        )
        
        /// 검색 결과 좌표
        let coord = geocodingInfo
            .map { $0?.coord }
            .eraseToAnyPublisher()
        
        return Output(coord: coord)
    }
}

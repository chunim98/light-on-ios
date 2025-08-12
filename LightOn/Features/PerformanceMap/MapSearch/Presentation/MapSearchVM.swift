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
    }
    struct Output {
        /// 지오코딩 결과 셀 아이템 배열
        let searchResults: AnyPublisher<[MapSearchCellItem], Never>
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
        let geocodingInfoArr = getGeocodingInfoUC
            .execute(adress: input.address)
        
        /// 지오코딩 결과 셀 아이템으로 맵핑
        let searchResults = geocodingInfoArr
            .map { infoArr in infoArr.map { $0.toCellItem() } }
            .eraseToAnyPublisher()
        
        return Output(searchResults: searchResults)
    }
}

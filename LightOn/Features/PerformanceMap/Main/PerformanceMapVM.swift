//
//  PerformanceMapVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/21/25.
//

import Foundation
import Combine
import CoreLocation

final class PerformanceMapVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let cameraLocation: AnyPublisher<CLLocationCoordinate2D, Never>
    }
    struct Output {
        /// 위치 기반 공연정보 테이블 셀들
        let cellItems: AnyPublisher<[SpotlightedCellItem], Never>
        /// 위치 기반 공연정보 마커들
        let markerInfoArr: AnyPublisher<[MarkerInfo], Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let getPerformanceMapListUC: GetPerformanceMapListUC
    
    // MARK: Initializer
    
    init(repo: any PerformanceMapRepo) {
        self.getPerformanceMapListUC = .init(repo: repo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let performances = getPerformanceMapListUC.execute(
            cameraLocation: input.cameraLocation
        )
        
        let cellItems = performances
            .map { $0.map { $0.toCellItem() } }
            .eraseToAnyPublisher()
        
        let markerInfoArr = performances
            .map { $0.map { $0.toMarkerInfo() } }
            .eraseToAnyPublisher()

        return Output(
            cellItems: cellItems,
            markerInfoArr: markerInfoArr
        )
    }
}

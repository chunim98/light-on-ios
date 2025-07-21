//
//  NaverMapVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/21/25.
//

import Foundation
import CoreLocation
import Combine

final class NaverMapVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let cameraLocation: AnyPublisher<CLLocationCoordinate2D, Never>
    }
    struct Output {
        /// 카메라 좌표 기준 동 이름
        let dongName: AnyPublisher<String?, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let getDongNameUC: GetDongNameUC
    
    init(repo: ReverseGeocodingRepo) {
        self.getDongNameUC = .init(repo: repo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let dongName = getDongNameUC.execute(
            cameraLocation: input.cameraLocation
        )
        
        return Output(dongName: dongName)
    }
}

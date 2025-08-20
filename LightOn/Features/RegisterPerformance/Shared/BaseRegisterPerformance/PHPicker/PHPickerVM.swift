//
//  PHPickerVM.swift
//  TennisPark
//
//  Created by 신정욱 on 7/2/25.
//

import Foundation
import Combine
import PhotosUI

final class PHPickerVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        /// PHPicker 선택 결과
        let pickingResults: AnyPublisher<[PHPickerResult], Never>
    }
    struct Output {
        /// 취소 버튼 탭
        let cancelTap: AnyPublisher<Void, Never>
        /// 선택한 이미지 정보
        let selectedImageInfo: AnyPublisher<ImageInfo, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let handlePickingResultsUC = HandlePickingResultsUC()
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        /// 선택한 이미지 정보
        let selectedImageInfo = handlePickingResultsUC.execute(
            pickingResults: input.pickingResults
        )
        
        /// 선택한 이미지가 없으면 취소버튼 탭으로 간주
        let cancelTap = selectedImageInfo
            .compactMap { $0 != nil ? nil : Void() }
            .eraseToAnyPublisher()
        
        /// 선택한 이미지가 존재하는지 검증
        let validSelectedImage = selectedImageInfo
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        return Output(
            cancelTap: cancelTap,
            selectedImageInfo: validSelectedImage
        )
    }
}

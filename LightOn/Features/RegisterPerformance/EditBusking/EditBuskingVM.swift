//
//  EditBuskingVM.swift
//  LightOn
//
//  Created by 신정욱 on 8/21/25.
//

import Foundation
import Combine

final class EditBuskingVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let name: AnyPublisher<String?, Never>
        let description: AnyPublisher<String?, Never>
        let regionID: AnyPublisher<Int?, Never>
        let detailAddress: AnyPublisher<String?, Never>
        let notice: AnyPublisher<String?, Never>
        let genre: AnyPublisher<[String], Never>
        let posterInfo: AnyPublisher<ImageInfo, Never>
        let startDate: AnyPublisher<String?, Never>
        let endDate: AnyPublisher<String?, Never>
        let startTime: AnyPublisher<String?, Never>
        let endTime: AnyPublisher<String?, Never>
        let documentInfo: AnyPublisher<ImageInfo, Never>
        let artistName: AnyPublisher<String?, Never>
        let artistDescription: AnyPublisher<String?, Never>
        let alertConfirmTap: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 버스킹 등록 완료 이벤트
        let registerCompleteEvent: AnyPublisher<Void, Never>
        /// 모든 필드가 유효한지 여부
        let allValuesValid: AnyPublisher<Bool, Never>
        /// 최초 로드 시 바인딩할 공연 정보
        let initialInfo: AnyPublisher<RegisterBuskingInfo, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let performanceID: Int
    private let editBuskingRepo: EditBuskingRepo
    
    // MARK: Initializer
    
    init(performanceID: Int, repo: any EditBuskingRepo) {
        self.performanceID = performanceID
        self.editBuskingRepo = repo
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        /// 공연 정보 상태
        let infoSubject = CurrentValueSubject<RegisterBuskingInfo, Never>(.init())

        /// 초기 할당 공연 정보
        let initialInfo = editBuskingRepo.getPerformanceDetail(id: performanceID)
        
        // 상태 초기화
        initialInfo
            .sink { infoSubject.send($0) }
            .store(in: &cancellables)
        
        /// 모든 필드가 유효한지 여부
        let allValuesValid = infoSubject
            .map { $0.allValuesValid }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        // info 상태 갱신
        [
            input.name.sink              { infoSubject.value.name              = $0 },
            input.description.sink       { infoSubject.value.description       = $0 },
            input.regionID.sink          { infoSubject.value.regionID          = $0 },
            input.detailAddress.sink     { infoSubject.value.detailAddress     = $0 },
            input.notice.sink            { infoSubject.value.notice            = $0 },
            input.genre.sink             { infoSubject.value.genre             = $0 },
            input.posterInfo.sink        { infoSubject.value.posterInfo        = $0 },
            input.startDate.sink         { infoSubject.value.startDate         = $0 },
            input.endDate.sink           { infoSubject.value.endDate           = $0 },
            input.startTime.sink         { infoSubject.value.startTime         = $0 },
            input.endTime.sink           { infoSubject.value.endTime           = $0 },
            input.documentInfo.sink      { infoSubject.value.documentInfo      = $0 },
            input.artistName.sink        { infoSubject.value.artistName        = $0 },
            input.artistDescription.sink { infoSubject.value.artistDescription = $0 },
        ].forEach { $0.store(in: &cancellables) }
        
        return Output(
            registerCompleteEvent: Empty().eraseToAnyPublisher(),
            allValuesValid: allValuesValid,
            initialInfo: initialInfo
        )
    }
}

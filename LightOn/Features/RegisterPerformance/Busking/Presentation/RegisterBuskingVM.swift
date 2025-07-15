//
//  RegisterBuskingVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/14/25.
//

import Foundation
import Combine

final class RegisterBuskingVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let name: AnyPublisher<String?, Never>
        let description: AnyPublisher<String?, Never>
        let regionID: AnyPublisher<Int?, Never>
        let detailAddress: AnyPublisher<String?, Never>
        let notice: AnyPublisher<String?, Never>
        let genre: AnyPublisher<[String], Never>
        let posterPath: AnyPublisher<String?, Never>
        let startDate: AnyPublisher<String?, Never>
        let endDate: AnyPublisher<String?, Never>
        let startTime: AnyPublisher<String?, Never>
        let endTime: AnyPublisher<String?, Never>
        let documentPath: AnyPublisher<String?, Never>
        let artistName: AnyPublisher<String?, Never>
        let artistDescription: AnyPublisher<String?, Never>
        let alertConfirmTap: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 입력값 상태
        let info: AnyPublisher<RegisterBuskingInfo, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let infoSubject = CurrentValueSubject<RegisterBuskingInfo, Never>(.init())
        
        // info 상태 갱신
        [
            input.name.sink              { infoSubject.value.name              = $0 },
            input.description.sink       { infoSubject.value.description       = $0 },
            input.regionID.sink          { infoSubject.value.regionID          = $0 },
            input.detailAddress.sink     { infoSubject.value.detailAddress     = $0 },
            input.notice.sink            { infoSubject.value.notice            = $0 },
            input.genre.sink             { infoSubject.value.genre             = $0 },
            input.posterPath.sink        { infoSubject.value.posterPath        = $0 },
            input.startDate.sink         { infoSubject.value.startDate         = $0 },
            input.endDate.sink           { infoSubject.value.endDate           = $0 },
            input.startTime.sink         { infoSubject.value.startTime         = $0 },
            input.endTime.sink           { infoSubject.value.endTime           = $0 },
            input.documentPath.sink      { infoSubject.value.documentPath      = $0 },
            input.artistName.sink        { infoSubject.value.artistName        = $0 },
            input.artistDescription.sink { infoSubject.value.artistDescription = $0 },
        ].forEach { $0.store(in: &cancellables) }
        
        return Output(info: infoSubject.eraseToAnyPublisher())
    }
}

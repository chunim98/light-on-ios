//
//  RegisterConcertVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/15/25.
//

import Foundation
import Combine

final class RegisterConcertVM {
    
    // MARK: Input & Output
    
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
        
        let isPaid: AnyPublisher<Bool?, Never>
        let price: AnyPublisher<Int?, Never>
        let account: AnyPublisher<String?, Never>
        let bank: AnyPublisher<String?, Never>
        let accountHolder: AnyPublisher<String?, Never>
        
        let artists: AnyPublisher<[Int]?, Never>
        let seatType: AnyPublisher<[String], Never>
        let documentPath: AnyPublisher<String?, Never>
    }
    
    struct Output {
        /// 입력값 상태
        let info: AnyPublisher<RegisterConcertInfo, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let infoSubject = CurrentValueSubject<RegisterConcertInfo, Never>(.init())
        
        // info 상태 갱신
        [
            input.name.sink             { infoSubject.value.name           = $0 },
            input.description.sink      { infoSubject.value.description    = $0 },
            input.regionID.sink         { infoSubject.value.regionID       = $0 },
            input.detailAddress.sink    { infoSubject.value.detailAddress  = $0 },
            input.notice.sink           { infoSubject.value.notice         = $0 },
            input.genre.sink            { infoSubject.value.genre          = $0 },
            input.posterPath.sink       { infoSubject.value.posterPath     = $0 },
            
            input.startDate.sink        { infoSubject.value.startDate      = $0 },
            input.endDate.sink          { infoSubject.value.endDate        = $0 },
            input.startTime.sink        { infoSubject.value.startTime      = $0 },
            input.endTime.sink          { infoSubject.value.endTime        = $0 },
            
            input.isPaid.sink           { infoSubject.value.isPaid         = $0 },
            input.price.sink            { infoSubject.value.price          = $0 },
            input.account.sink          { infoSubject.value.account        = $0 },
            input.bank.sink             { infoSubject.value.bank           = $0 },
            input.accountHolder.sink    { infoSubject.value.accountHolder  = $0 },
            
            input.artists.sink          { infoSubject.value.artists        = $0 },
            input.seatType.sink         { infoSubject.value.seatType       = $0 },
            input.documentPath.sink     { infoSubject.value.documentPath   = $0 },
        ].forEach { $0.store(in: &cancellables) }
        
        return Output(info: infoSubject.eraseToAnyPublisher())
    }
}

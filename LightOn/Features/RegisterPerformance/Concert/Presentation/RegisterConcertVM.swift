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
        let title: AnyPublisher<String?, Never>
        let description: AnyPublisher<String?, Never>
        let regionID: AnyPublisher<Int?, Never>
        let place: AnyPublisher<String?, Never>
        let notice: AnyPublisher<String?, Never>
        let genre: AnyPublisher<[String], Never>
        
        let startDate: AnyPublisher<String?, Never>
        let endDate: AnyPublisher<String?, Never>
        let startTime: AnyPublisher<String?, Never>
        let endTime: AnyPublisher<String?, Never>
        
        let isPaid: AnyPublisher<Bool, Never>
        let price: AnyPublisher<Int?, Never>
        let account: AnyPublisher<String?, Never>
        let bank: AnyPublisher<String?, Never>
        let accountHolder: AnyPublisher<String?, Never>
        
        let seatTypes: AnyPublisher<[RegisterConcertInfo.SeatType], Never>
        let totalSeatsCount: AnyPublisher<Int?, Never>
        
        let posterInfo: AnyPublisher<ImageInfo, Never>
        let documentInfo: AnyPublisher<ImageInfo, Never>
        
        let alertConfirmTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        /// 필드를 채울 아티스트 정보 초기값
        let initialArtistInfo: AnyPublisher<ArtistInfo, Never>
        /// 콘서트 등록 완료 이벤트
        let registerCompleteEvent: AnyPublisher<Void, Never>
        /// 모든 필드가 유효한지 여부
        let allValuesValid: AnyPublisher<Bool, Never>
        
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let fetchArtistInfoUC: FetchArtistInfoUC
    private let registerConcertUC: RegisterConcertUC
    
    // MARK: Initializer
    
    init(
        artistInfoRepo: any ArtistInfoRepo,
        registerConcertRepo: any RegisterConcertRepo
    ) {
        self.fetchArtistInfoUC = .init(repo: artistInfoRepo)
        self.registerConcertUC = .init(repo: registerConcertRepo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let infoSubject = CurrentValueSubject<RegisterConcertInfo, Never>(.init())
        
        /// 아티스트 정보 필드 초기값
        let initialArtistInfo = fetchArtistInfoUC.execute()
        
        /// 아티스트 정보를 불러와 초기상태 구성
        initialArtistInfo
            .sink {
                infoSubject.value.artistDescription = $0.artistDescription
                infoSubject.value.artistName = $0.artistName
            }
            .store(in: &cancellables)
        
        /// 콘서트 등록 완료 이벤트
        let registerCompleteEvent = registerConcertUC.execute(
            trigger: input.alertConfirmTap,
            info: infoSubject.eraseToAnyPublisher()
        )
        
        /// 모든 필드가 유효한지 여부
        let allValuesValid = infoSubject
            .map { $0.allValuesValid }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        // info 상태 갱신
        [
            input.title.sink           { infoSubject.value.title           = $0 },
            input.description.sink     { infoSubject.value.description     = $0 },
            input.regionID.sink        { infoSubject.value.regionID        = $0 },
            input.place.sink           { infoSubject.value.place           = $0 },
            input.notice.sink          { infoSubject.value.notice          = $0 },
            input.genre.sink           { infoSubject.value.genre           = $0 },
            
            input.startDate.sink       { infoSubject.value.startDate       = $0 },
            input.endDate.sink         { infoSubject.value.endDate         = $0 },
            input.startTime.sink       { infoSubject.value.startTime       = $0 },
            input.endTime.sink         { infoSubject.value.endTime         = $0 },
            
            input.isPaid.sink          { infoSubject.value.isPaid          = $0 },
            input.price.sink           { infoSubject.value.price           = $0 },
            input.account.sink         { infoSubject.value.account         = $0 },
            input.bank.sink            { infoSubject.value.bank            = $0 },
            input.accountHolder.sink   { infoSubject.value.accountHolder   = $0 },
            
            input.seatTypes.sink       { infoSubject.value.seatTypes       = $0 },
            input.totalSeatsCount.sink { infoSubject.value.totalSeatsCount = $0 },
            
            input.posterInfo.sink      { infoSubject.value.posterInfo      = $0 },
            input.documentInfo.sink    { infoSubject.value.documentInfo    = $0 },
        ].forEach { $0.store(in: &cancellables) }
        
        return Output(
            initialArtistInfo: initialArtistInfo,
            registerCompleteEvent: registerCompleteEvent,
            allValuesValid: allValuesValid
        )
    }
}

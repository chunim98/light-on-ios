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
        
        let artists: AnyPublisher<[Int]?, Never>
        let seatTypes: AnyPublisher<[RegisterConcertInfo.SeatType], Never>
        let totalSeatsCount: AnyPublisher<Int?, Never>
        
        let posterInfo: AnyPublisher<ImageInfo, Never>
        let documentInfo: AnyPublisher<ImageInfo, Never>
    }
    
    struct Output {
        /// 입력값 상태
        let info: AnyPublisher<RegisterConcertInfo, Never>
        /// 필드를 채울 아티스트 정보 초기값
        let initialArtistInfo: AnyPublisher<ArtistInfo, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let fetchArtistInfoUC: FetchArtistInfoUC
    
    // MARK: Initializer
    
    init(repo: any ArtistInfoRepo) {
        self.fetchArtistInfoUC = .init(repo: repo)
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
            
            input.artists.sink         { infoSubject.value.artists         = $0 },
            input.seatTypes.sink       { infoSubject.value.seatTypes       = $0 },
            input.totalSeatsCount.sink { infoSubject.value.totalSeatsCount = $0 },
            
            input.posterInfo.sink      { infoSubject.value.posterInfo      = $0 },
            input.documentInfo.sink    { infoSubject.value.documentInfo    = $0 },
        ].forEach { $0.store(in: &cancellables) }
        
        return Output(
            info: infoSubject.eraseToAnyPublisher(),
            initialArtistInfo: initialArtistInfo
        )
    }
}

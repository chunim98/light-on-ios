//
//  ModifyConcertVM.swift
//  LightOn
//
//  Created by 신정욱 on 9/7/25.
//

import Foundation
import Combine

final class ModifyConcertVM {
    
    // MARK: Input & Ouput
    
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
        
        let isStanding: AnyPublisher<Bool, Never>
        let isFreestyle: AnyPublisher<Bool, Never>
        let isAssigned: AnyPublisher<Bool, Never>
        let totalSeatsCount: AnyPublisher<Int?, Never>
        
        let posterInfo: AnyPublisher<ImageInfo, Never>
        let documentInfo: AnyPublisher<ImageInfo, Never>
        
        /// 콘서트수정 확인 탭
        let editConfirmTap: AnyPublisher<Void, Never>
        /// 콘서트 삭제 탭
        let deleteConfirmTap: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 최초 로드 시 바인딩할 콘서트 정보
        let initialInfo: AnyPublisher<ConcertInfo, Never>
        /// 콘서트 수정 완료 이벤트
        let editComplete: AnyPublisher<Void, Never>
        /// 콘서트 삭제 완료 이벤트
        let deleteComplete: AnyPublisher<Void, Never>
        /// 콘서트 수정이 가능한지 여부
        let buskingEditable: AnyPublisher<Bool, Never>
        /// 콘서트 취소가 가능한지 여부
        let buskingCancellable: AnyPublisher<Bool, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let performanceID: Int
    private let fetchConcertInfoUC: FetchConcertInfoUC
    private let editConcertUC: EditConcertUC
    private let deleteConcertUC: DeleteConcertUC
    private let validateModificationUC = ValidateConcertModificationUC()
    
    // MARK: Initializer
    
    init(
        performanceID: Int,
        modifyConcertRepo: any ModifyConcertRepo
    ) {
        self.performanceID = performanceID
        self.fetchConcertInfoUC = .init(repo: modifyConcertRepo)
        self.editConcertUC = .init(repo: modifyConcertRepo)
        self.deleteConcertUC = .init(repo: modifyConcertRepo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        /// 콘서트 정보 상태
        let infoSubject = CurrentValueSubject<ConcertInfo, Never>(.init())
        
        /// 초기 할당 콘서트 정보
        let initialInfo = fetchConcertInfoUC.execute(id: performanceID)
        
        /// 콘서트 수정이 가능한지 여부
        let buskingEditable = validateModificationUC.validateEditable(
            initialInfo: initialInfo,
            currentInfo: infoSubject.eraseToAnyPublisher()
        )
        
        /// 콘서트 취소가 가능한지 여부
        let buskingCancellable = validateModificationUC.validateCancellable(
            initialInfo: initialInfo
        )
        
        // 콘서트 수정 요청
        let editComplete = editConcertUC.execute(
            trigger: input.editConfirmTap,
            id: performanceID,
            info: infoSubject.eraseToAnyPublisher()
        )
        
        // 콘서트 삭제 요청
        let buskingDeleted = deleteConcertUC.execute(
            trigger: input.deleteConfirmTap,
            id: performanceID
        )
        
        // info 상태 갱신
        [
            initialInfo.sink           { infoSubject.value                 = $0 }, // 초기값 할당
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
            
            input.isStanding.sink      { infoSubject.value.isStanding      = $0 },
            input.isFreestyle.sink     { infoSubject.value.isFreestyle     = $0 },
            input.isAssigned.sink      { infoSubject.value.isAssigned      = $0 },
            input.totalSeatsCount.sink { infoSubject.value.totalSeatsCount = $0 },
            
            input.posterInfo.sink      { infoSubject.value.posterInfo      = $0 },
            input.documentInfo.sink    { infoSubject.value.documentInfo    = $0 },
        ].forEach { $0.store(in: &cancellables) }
        
        return Output(
            initialInfo: initialInfo,
            editComplete: editComplete,
            deleteComplete: buskingDeleted,
            buskingEditable: buskingEditable,
            buskingCancellable: buskingCancellable
        )
    }
}

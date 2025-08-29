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
        /// 버스킹수정 확인 탭
        let editConfirmTap: AnyPublisher<Void, Never>
        /// 버스킹 삭제 탭
        let deleteConfirmTap: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 최초 로드 시 바인딩할 버스킹 정보
        let initialInfo: AnyPublisher<BuskingInfo, Never>
        /// 버스킹 수정 완료 이벤트
        let editComplete: AnyPublisher<Void, Never>
        /// 버스킹 삭제 완료 이벤트
        let deleteComplete: AnyPublisher<Void, Never>
        /// 버스킹 수정이 가능한지 여부
        let buskingEditable: AnyPublisher<Bool, Never>
        /// 버스킹 취소가 가능한지 여부
        let buskingCancellable: AnyPublisher<Bool, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let performanceID: Int
    private let getBuskingInfoUC: GetBuskingInfoUC
    private let editBuskingUC: EditBuskingUC
    private let deleteBuskingUC: DeleteBuskingUC
    private let validateModificationUC = ValidateBuskingModificationUC()
    
    // MARK: Initializer
    
    init(
        performanceID: Int,
        editBuskingRepo: any EditBuskingRepo,
        deleteBuskingRepo: any DeleteBuskingRepo
    ) {
        self.performanceID = performanceID
        self.getBuskingInfoUC = .init(repo: editBuskingRepo)
        self.editBuskingUC = .init(repo: editBuskingRepo)
        self.deleteBuskingUC = .init(repo: deleteBuskingRepo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        /// 버스킹 정보 상태
        let infoSubject = CurrentValueSubject<BuskingInfo, Never>(.init())
        
        /// 초기 할당 버스킹 정보
        let initialInfo = getBuskingInfoUC.execure(id: performanceID)
        
        /// 버스킹 수정이 가능한지 여부
        let buskingEditable = validateModificationUC.validateEditable(
            initialInfo: initialInfo,
            currentInfo: infoSubject.eraseToAnyPublisher()
        )
        
        /// 버스킹 취소가 가능한지 여부
        let buskingCancellable = validateModificationUC.validateCancellable(
            initialInfo: initialInfo
        )
        
        // 버스킹 수정 요청
        let editComplete = editBuskingUC.execute(
            trigger: input.editConfirmTap,
            id: performanceID,
            info: infoSubject.eraseToAnyPublisher()
        )
        
        // 버스킹 삭제 요청
        let buskingDeleted = deleteBuskingUC.execute(
            trigger: input.deleteConfirmTap,
            id: performanceID
        )
        
        // info 상태 갱신
        [
            initialInfo.sink              { infoSubject.value = $0 }, // 초기값 할당
            input.name.sink               { infoSubject.value.name = $0 },
            input.description.sink        { infoSubject.value.description = $0 },
            input.regionID.sink           { infoSubject.value.regionID = $0 },
            input.detailAddress.sink      { infoSubject.value.detailAddress = $0 },
            input.notice.sink             { infoSubject.value.notice = $0 },
            input.genre.sink              { infoSubject.value.genre = $0 },
            input.posterInfo.sink         { infoSubject.value.posterInfo = $0 },
            input.startDate.sink          { infoSubject.value.startDate = $0 },
            input.endDate.sink            { infoSubject.value.endDate = $0 },
            input.startTime.sink          { infoSubject.value.startTime = $0 },
            input.endTime.sink            { infoSubject.value.endTime = $0 },
            input.documentInfo.sink       { infoSubject.value.documentInfo = $0 },
            input.artistName.sink         { infoSubject.value.artistName = $0 },
            input.artistDescription.sink  { infoSubject.value.artistDescription = $0 },
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

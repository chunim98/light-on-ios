//
//  SelectLikingVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/3/25.
//

import Foundation
import Combine

final class SelectLikingVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let selectedItem: AnyPublisher<GenreCellItem, Never>
        let nextButtonTap: AnyPublisher<Void, Never>
    }
    struct Output {
        /// 장르 셀 아이템 배열
        let genreCellItems: AnyPublisher<[GenreCellItem], Never>
        /// 다음 버튼 활성화 여부
        let nextButtonEnabled: AnyPublisher<Bool, Never>
        /// 장르 전송 완료 이벤트
        let postCompletion: AnyPublisher<Void, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let updateGenreCellItemUC = UpdateGenreCellItemUC()
    private let postLikingGenreUC: PostLikingGenreUC
    
    // MARK: Initializer
    
    init(likingGenreRepo: LikingGenreRepo) {
        self.postLikingGenreUC = PostLikingGenreUC(repo: likingGenreRepo)
    }
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let genreCellItemsSubject = CurrentValueSubject<[GenreCellItem], Never>(
            GenreCellItem.genres
        )
        
        updateGenreCellItemUC.execute(
            selectedItem: input.selectedItem,
            genreItems: genreCellItemsSubject.eraseToAnyPublisher()
        )
        .sink { genreCellItemsSubject.send($0) }
        .store(in: &cancellables)
        
        // 선택된 장르가 하나 이상일 때 버튼 활성화
        let nextButtonEnabled = genreCellItemsSubject
            .map { items in !(items.filter { $0.isSelected }.isEmpty) }
            .eraseToAnyPublisher()
        
        let postCompletion = postLikingGenreUC.execute(
            trigger: input.nextButtonTap,
            genreItems: genreCellItemsSubject.eraseToAnyPublisher()
        )
        
        return Output(
            genreCellItems: genreCellItemsSubject.eraseToAnyPublisher(),
            nextButtonEnabled: nextButtonEnabled,
            postCompletion: postCompletion
        )
    }
}

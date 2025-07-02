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
    }
    struct Output {
        /// 장르 셀 아이템 배열
        let genreCellItems: AnyPublisher<[GenreCellItem], Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let updateGenreCellItemUC = UpdateGenreCellItemUC()
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let genreCellItemsSubject = CurrentValueSubject<[GenreCellItem], Never>(
            GenreCellItem.genres
        )
        
        updateGenreCellItemUC.execute(
            selectedItem: input.selectedItem,
            cellItems: genreCellItemsSubject.eraseToAnyPublisher()
        )
        .sink { genreCellItemsSubject.send($0) }
        .store(in: &cancellables)
        
        return Output(
            genreCellItems: genreCellItemsSubject.eraseToAnyPublisher()
        )
    }
}

//
//  GenreFormVM.swift
//  LightOn
//
//  Created by 신정욱 on 7/12/25.
//

import Foundation
import Combine

final class GenreFormVM {
    
    // MARK: Input & Ouput
    
    struct Input {
        let buttonTap: AnyPublisher<Void, Never>
        let dismissTableEvent: AnyPublisher<Void, Never>
        let selectedGenre: AnyPublisher<GenreCellItem, Never>
    }
    struct Output {
        /// 드롭다운 뷰 상태
        let state: AnyPublisher<GenreDropdownState, Never>
        /// 선택한 장르 아이디
        let selectedGenreID: AnyPublisher<Int?, Never>
    }
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Event Handling
    
    func transform(_ input: Input) -> Output {
        let stateSubject = CurrentValueSubject<GenreDropdownState, Never>(.init(
            tableHidden: true, selectedGenre: nil
        ))
        
        let state = stateSubject.eraseToAnyPublisher()
        
        let selectedGenreID = state
            .map { $0.selectedGenre?.id }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        // 드롭다운 뷰 상태 업데이트
        Publishers.Merge3(
            input.buttonTap.withLatestFrom(state) {
                $1.updated(tableHidden: false)
            },
            input.dismissTableEvent.withLatestFrom(state) {
                $1.updated(tableHidden: true)
            },
            input.selectedGenre.withLatestFrom(state) {
                $1.updated(tableHidden: true, selectedGenre: .some($0))
            }
        )
        .sink { stateSubject.send($0) }
        .store(in: &cancellables)
        
        return Output(state: state, selectedGenreID: selectedGenreID)
    }
}

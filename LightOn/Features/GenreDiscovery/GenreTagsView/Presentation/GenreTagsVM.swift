//
//  GenreTagsVM.swift
//  LightOn
//
//  Created by 신정욱 on 6/11/25.
//

import Combine

final class GenreTagsVM: ObservableObject {
    
    // MARK: State & Intent
    
    struct State {
        var items: [GenreTagItem]
    }
    enum Intent {
        /// 버튼을 탭하면 선택한 인덱스 방출
        case buttonTap(Int)
    }
    
    // MARK: Properties
    
    @Published private(set) var state = State(items: GenreTagItem.mocks)
    let intent = PassthroughSubject<Intent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Initializer (Intent Binding)
    
    init() {
        intent
            .sink { [weak self] in self?.process($0) }
            .store(in: &cancellables)
    }
    
    // MARK: Intent Handling
    
    private func process(_ intent: Intent) {
        switch intent {
        case .buttonTap(let tag):
            state.items = state.items.map {
                $0.updated(isSelected: $0.tag == tag)
            }
        }
    }
}

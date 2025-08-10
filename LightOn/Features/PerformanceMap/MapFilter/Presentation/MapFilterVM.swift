//
//  MapFilterVM.swift
//  LightOn
//
//  Created by 신정욱 on 8/10/25.
//

import Combine

final class MapFilterVM: ObservableObject {
    
    // MARK: State & Intent
    
    struct State {
        var items: [MapFilterTagItem] = [
            .init(tagType: .recommend),
            .init(tagType: .recent),
            .init(tagType: .closingSoon),
            .init(tagType: .myGenre),
        ]
    }
    enum Intent {
        case tagTap(MapFilterType)
    }
    
    // MARK: Properties
    
    @Published private(set) var state = State()
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
        case .tagTap(let type):
            let alreadySelected = state.items.first {
                $0.isSelected && $0.tagType == type
            } != nil
            
            state.items = state.items.map {
                let selected = alreadySelected ? false : $0.tagType == type
                return $0.updated(isSelected: selected)
            }
        }
    }
}

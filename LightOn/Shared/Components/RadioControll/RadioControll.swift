//
//  RadioControll.swift
//  LightOn
//
//  Created by 신정욱 on 5/22/25.
//

import UIKit
import Combine

import CombineCocoa

final class RadioControll: UIStackView {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let isRequired: Bool
    
    /// 타이틀이 설정되면 초기화
    var titles = [String]() { didSet {
        setupDefaults()
        setupLayout()
        setupBindings()
    } }
    
    // MARK: Outputs
    
    private let selectedIndexSubject: CurrentValueSubject<Int, Never>
    
    // MARK: Components
    
    private var buttons = [RadioControllButton]()
    
    // MARK: Life Cycle
    
    init(isRequired: Bool) {
        self.isRequired = isRequired
        self.selectedIndexSubject = .init(isRequired ? 0 : -1)
        super.init(frame: .zero)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        inset = .init(horizontal: 2)
        distribution = .fillEqually
        spacing = 26
        
        buttons = titles.enumerated().map {
            RadioControllButton(title: $1, tag: $0)
        }
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        buttons.forEach { addArrangedSubview($0) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let selectedTags = buttons.map { btn in
            btn.tapPublisher.map { _ in btn.tag }
        }
        
        // 눌린 버튼 특정해서 현재 상태 변경 시도
        Publishers.MergeMany(selectedTags)
            .withLatestFrom(selectedIndexSubject) { [isRequired] in
                // 필수 항목일 경우, 아무것도 선택되지 않는 경우(-1)는 없음
                isRequired ? $0 : ($0 == $1 ? -1 : $0)
            }
            .sink { [weak self] in self?.selectedIndexSubject.send($0) }
            .store(in: &cancellables)
        
        // 변경된 상태 버튼에 바인딩
        selectedIndexSubject
            .sink { [weak self] in self?.selectIndex($0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Observable

extension RadioControll {
    /// 선택된 인덱스에 따라서 버튼 UI 갱신
    func selectIndex(_ tag: Int) {
        buttons.forEach { $0.isSelected = ($0.tag == tag) }
    }
    
    /// 선택한 버튼 인덱스 퍼블리셔
    var selectedIndexPublisher: AnyPublisher<Int, Never> {
        selectedIndexSubject.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview {
    let button = RadioControll(isRequired: true)
    button.titles = ["인스타", "친구 추천", "추가"]
    return button
}

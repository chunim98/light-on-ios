//
//  PerformanceNameForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/5/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class PerformanceNameForm: BaseForm {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = PerformanceNameFormVM()
    
    // MARK: Components
    
    let textView = {
        let tv = PlaceholderTextView()
        tv.placeHolderLabel.config.text = "공연명을 입력해주세요 (50자 이내)"
        return tv
    }()
    
    let byteLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .caption
        config.alignment = .right
        config.text = "0/50" // temp
        return LOLabel(config: config)
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        titleLabel.config.text = "공연명"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(textView)
        addArrangedSubview(byteLabel)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let text = textView.textPublisher
            .compactMap { $0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        let input = PerformanceNameFormVM.Input(
            text: text,
            didBeginEditing: textView.didBeginEditingPublisher,
            didEndEditing: textView.didEndEditingPublisher
        )
        
        let output = vm.transform(input)
        
        output.state
            .sink { [weak self] in self?.bindState(state: $0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension PerformanceNameForm {
    /// 상태 바인딩
    private func bindState(state: PerformanceNameFormState) {
        // 값
        byteLabel.config.text = "\(state.byte)/50"
        // 스타일
        textView.layer.borderColor = state.style.fieldBorderColor.cgColor
        titleLabel.config.foregroundColor = state.style.titleColor
        byteLabel.config.foregroundColor = state.style.byteColor
    }
}

// MARK: - Preview

#Preview { PerformanceNameForm() }

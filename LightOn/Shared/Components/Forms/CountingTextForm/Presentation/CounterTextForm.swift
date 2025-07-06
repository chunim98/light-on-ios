//
//  CounterTextForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/5/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class CounterTextForm: BaseForm {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm: CounterTextFormVM
    
    // MARK: Outputs
    
    private let validTextSubject = PassthroughSubject<String?, Never>()
    
    // MARK: Components
    
    let textField = {
        let tf = LOTextField()
        tf.snp.makeConstraints { $0.height.equalTo(47) }
        return tf
    }()
    
    private let byteLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .caption
        config.alignment = .right
        return LOLabel(config: config)
    }()
    
    // MARK: Life Cycle
    
    init(maxByte: Int) {
        self.vm = .init(maxByte: maxByte)
        super.init(frame: .zero)
        setupLayout()
        setupBindings()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(textField)
        addArrangedSubview(byteLabel)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let text = textField.textPublisher
            .compactMap { $0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        let input = CounterTextFormVM.Input(
            text: text,
            didBeginEditing: textField.didBeginEditingPublisher,
            didEndEditing: textField.controlEventPublisher(for: .editingDidEnd)
        )
        
        let output = vm.transform(input)
        
        output.state
            .sink { [weak self] in self?.bindState(state: $0) }
            .store(in: &cancellables)
        
        output.validText
            .sink { [weak self] in self?.validTextSubject.send($0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension CounterTextForm {
    /// 상태 바인딩
    private func bindState(state: CounterTextFormState) {
        // 값
        byteLabel.config.text = "\(state.byte)/\(state.maxByte)"
        // 스타일
        textField.layer.borderColor = state.style.fieldBorderColor.cgColor
        titleLabel.config.foregroundColor = state.style.titleColor
        byteLabel.config.foregroundColor = state.style.byteColor
    }
    
    /// 유효한 텍스트 퍼블리셔
    var validTextPublisher: AnyPublisher<String?, Never> {
        validTextSubject.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { CounterTextForm(maxByte: 20) }

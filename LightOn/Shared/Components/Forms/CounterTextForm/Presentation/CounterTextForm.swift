//
//  CounterTextForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/12/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class CounterTextForm: BaseForm {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm: CounterTextFormVM
    
    // MARK: Subjects
    
    /// 유효한 텍스트 서브젝트(출력용)
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
        let text = textField.textChangesPublisher
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
        byteLabel.config.text = "\(state.nowByte)/\(state.maxByte)"
        
        let style = state.toStyle()
        textField.layer.borderColor = style.borderColor.cgColor
        titleLabel.config.foregroundColor = style.titleColor
        byteLabel.config.foregroundColor = style.byteColor
    }
    
    /// 유효한 텍스트 퍼블리셔
    var validTextPublisher: AnyPublisher<String?, Never> {
        validTextSubject.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview {
    let form = CounterTextForm(maxByte: 20)
    form.titleLabel.config.text = "타이틀"
    return form
}

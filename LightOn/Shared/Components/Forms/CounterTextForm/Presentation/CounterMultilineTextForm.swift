//
//  CounterMultilineTextForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/7/25.
//

import UIKit
import Combine

import CombineCocoa

final class CounterMultilineTextForm: BaseForm {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm: CounterTextFormVM
    
    // MARK: Outputs
    
    private let validTextSubject = PassthroughSubject<String?, Never>()
    
    // MARK: Components
    
    let textView = PlaceholderTextView()
    
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
        addArrangedSubview(textView)
        addArrangedSubview(byteLabel)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let text = textView.textPublisher
            .compactMap { $0 }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        let input = CounterTextFormVM.Input(
            text: text,
            didBeginEditing: textView.didBeginEditingPublisher,
            didEndEditing: textView.didEndEditingPublisher
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

extension CounterMultilineTextForm {
    /// 상태 바인딩
    private func bindState(state: CounterTextFormState) {
        byteLabel.config.text = "\(state.nowByte)/\(state.maxByte)"
        
        let style = state.toStyle()
        textView.layer.borderColor = style.borderColor.cgColor
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
    let form = CounterMultilineTextForm(maxByte: 20)
    form.titleLabel.config.text = "타이틀"
    return form
}

//
//  CounterTextForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/7/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class CounterTextForm: NTextForm {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm: CounterTextFormVM
    
    // MARK: Outputs
    
    private let validTextSubject = PassthroughSubject<String?, Never>()
    
    // MARK: Components
    
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
    
    // MARK: Style
    
    override func setStyle(status: FormStatus) {
        super.setStyle(status: status)
        switch status {
        case .empty:    byteLabel.config.foregroundColor = .caption
        case .editing:  byteLabel.config.foregroundColor = .caption
        case .filled:   byteLabel.config.foregroundColor = .caption
        case .invalid:  byteLabel.config.foregroundColor = .destructive
        }
    }
}

// MARK: Binders & Publishers

extension CounterTextForm {
    /// 상태 바인딩
    private func bindState(state: CounterTextFormState) {
        byteLabel.config.text = "\(state.nowByte)/\(state.maxByte)"
        setStyle(status: state.style)
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

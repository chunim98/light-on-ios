//
//  VerifyCodeForm.swift
//  LightOn
//
//  Created by 신정욱 on 5/22/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class VerifyCodeForm: TPTextForm {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    let timeLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.semiBold(16)
        config.foregroundColor = .brand
        config.underlineStyle = .single
        config.underlineColor = .brand
        config.lineHeight = 23
        return TPLabel(config: config)
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        titleHStack.isHidden = true // 타이틀 사용 안 함
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.trailing.equalTo(textField).inset(18)
            $0.centerY.equalTo(textField)
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        
        textField.didBeginEditingPublisher.sink { [weak self] _ in
            self?.textField.layer.borderColor = UIColor.brand.cgColor
        }
        .store(in: &cancellables)
        
        textField.controlEventPublisher(for: .editingDidEnd).sink { [weak self] _ in
            self?.textField.layer.borderColor = UIColor.thumbLine.cgColor
        }
        .store(in: &cancellables)
    }
}

// MARK: - Preview

#Preview { VerifyCodeForm() }

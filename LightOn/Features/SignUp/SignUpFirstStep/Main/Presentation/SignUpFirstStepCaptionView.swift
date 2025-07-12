//
//  SignUpFirstStepCaptionView.swift
//  LightOn
//
//  Created by 신정욱 on 7/10/25.
//

import UIKit

import SnapKit

final class SignUpFirstStepCaptionView: UIStackView {
    
    // MARK: Enum
    
    enum State {
        case hidden
        case valid(String)
        case invalid(String)
    }
    
    // MARK: Components
    
    private let imageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.snp.makeConstraints { $0.size.equalTo(18) }
        return iv
    }()
    
    private let label = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(12)
        return LOLabel(config: config)
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        inset = .init(leading: 2)
        alignment = .center
        spacing = 3
        
        isHidden = true
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(imageView)
        addArrangedSubview(label)
        addArrangedSubview(LOSpacer())
    }
    
    // MARK: Public Configuration
    
    /// 캡션 설정
    func setCaption(state: State) {
        switch state {
        case .hidden:
            isHidden = true
            
        case .valid(let text):
            imageView.image = .formFieldCheck
            label.config.foregroundColor = .brand
            label.config.text = text
            isHidden = false
            
        case .invalid(let text):
            imageView.image = .formFieldExclamation
            label.config.foregroundColor = .destructive
            label.config.text = text
            isHidden = false
        }
    }
}

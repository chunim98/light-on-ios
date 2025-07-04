//
//  PhoneNumberFormCaptionView.swift
//  LightOn
//
//  Created by 신정욱 on 6/30/25.
//

import UIKit

import SnapKit

final class PhoneNumberFormCaptionView: UIStackView {

    // MARK: Components
    
    private let imageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = .formFieldCheck
        iv.snp.makeConstraints { $0.size.equalTo(18) }
        return iv
    }()
    
    private let label = {
        var config = TextConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .brand
        config.text = "인증이 완료되었습니다."
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
    }
}

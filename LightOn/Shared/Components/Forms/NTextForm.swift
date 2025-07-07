//
//  NTextForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/7/25.
//

import UIKit

import SnapKit

class NTextForm: NBaseForm {
    
    // MARK: Components
    
    let textField = {
        let tf = LOTextField()
        tf.snp.makeConstraints { $0.height.equalTo(47) }
        return tf
    }()
    
    // MARK: Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(textField)
        textField.setContentHuggingPriority(.init(0), for: .horizontal)
        textField.setContentCompressionResistancePriority(.init(0), for: .horizontal)
    }
    
    // MARK: Style
    
    override func setStyle(flag: FormStyleFlag) {
        super.setStyle(flag: flag)
        switch flag {
        case .empty:    textField.layer.borderColor = UIColor.thumbLine.cgColor
        case .editing:  textField.layer.borderColor = UIColor.brand.cgColor
        case .filled:   textField.layer.borderColor = UIColor.loBlack.cgColor
        case .invalid:  textField.layer.borderColor = UIColor.destructive.cgColor
        }
    }
}

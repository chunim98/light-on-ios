//
//  NTextForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/7/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

class NTextForm: NBaseForm {
    
    // MARK: Components
    
    let textFieldHStack = UIStackView()
    
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
        addArrangedSubview(textFieldHStack)
        textFieldHStack.addArrangedSubview(textField)
    }
}

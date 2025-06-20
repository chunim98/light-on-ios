//
//  TPTextForm.swift
//  TennisParkForManager
//
//  Created by 신정욱 on 5/23/25.
//

import UIKit

import SnapKit

class TPTextForm: TPFormBase {

    // MARK: Components
    
    private let bodyHStack = UIStackView()
    
    let textField = TPTextField()
    
    // MARK: Life Cycle
    
    convenience init(isRequired: Bool) {
        self.init(frame: .zero)
        asteriskLabel.isHidden = !isRequired
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(bodyHStack)
        bodyHStack.addArrangedSubview(textField)
        
        textField.setContentHuggingPriority(.init(0), for: .horizontal)
        textField.setContentCompressionResistancePriority(.init(0), for: .horizontal)
        
        textField.snp.makeConstraints { $0.height.equalTo(47) }
    }
    
    // MARK: Public Configuration
    
    func addTrailingView(_ view: UIView) { bodyHStack.addArrangedSubview(view) }
}

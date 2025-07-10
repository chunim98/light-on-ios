//
//  DetailAddressForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/7/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class DetailAddressForm: AddressForm {
    
    // MARK: Properties
    
    
    // MARK: Components
    
    private let detailTextField = {
        let tf = LOTextField()
        tf.setPlaceHolder("상세주소")
        tf.snp.makeConstraints { $0.height.equalTo(47) }
        return tf
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        titleLabel.config.text = "공연 장소"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(detailTextField)
        self.snp.makeConstraints { $0.width.equalTo(350) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {}
}

// MARK: - Preview

#Preview { DetailAddressForm() }

//
//  SeatFormContainerView.swift
//  LightOn
//
//  Created by 신정욱 on 7/13/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class SeatFormContainerView: UIStackView {
    
    // MARK: Properties
    
    
    
    // MARK: Components
    
    private let titleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.semiBold(16)
        config.foregroundColor = .loBlack
        config.text = "좌석 정보"
        return LOLabel(config: config)
    }()

    private let seatCountForm = {
        let form = TextForm()
        form.textField.keyboardType = .numberPad
        form.textField.setPlaceHolder("예매 가능한 좌석수를 입력해주세요")
        form.titleLabel.config.text = "좌석수"
        return form
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
        inset = .init(vertical: 20)
        axis = .vertical
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(LOSpacer(16))
        
        
        
    }
    
    // MARK: Bindings
    
    private func setupBindings() {}
    
    // MARK: Public Configuration
    
    // MARK: Binders & Publishers

}

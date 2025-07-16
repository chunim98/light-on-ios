//
//  PerformanceDetailBaseModalVC.swift
//  LightOn
//
//  Created by 신정욱 on 7/16/25.
//

import UIKit
import Combine

class PerformanceDetailBaseModalVC: ModalVC {
    
    // MARK: Properties
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let buttonsHStack = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    let descriptionLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(18)
        config.foregroundColor = .caption
        config.alignment = .center
        return LOLabel(config: config)
    }()
    
    let acceptButton = LOButton(style: .filled)
    let cancelButton = LOButton(style: .bordered)
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() { titleLabel.config.text = "공연 신청" }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentVStack.addArrangedSubview(descriptionLabel)
        contentVStack.addArrangedSubview(buttonsHStack)
        buttonsHStack.addArrangedSubview(cancelButton)
        buttonsHStack.addArrangedSubview(acceptButton)
    }
}

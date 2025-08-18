//
//  BaseAlertVC.swift
//  LightOn
//
//  Created by 신정욱 on 6/25/25.
//

import UIKit

import SnapKit

class BaseAlertVC: CombineVC {
    
    // MARK: Components
    
    let contentVStack = {
        let sv = UIStackView(.vertical)
        sv.inset = .init(horizontal: 18, vertical: 28)
        sv.backgroundColor = .white
        sv.layer.cornerRadius = 10
        sv.clipsToBounds = true
        return sv
    }()
    
    let titleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.bold(22)
        config.foregroundColor = .loBlack
        config.alignment = .center
        config.lineHeight = 28.6
        return LOLabel(config: config)
    }()
    
    let descriptionLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(18)
        config.foregroundColor = .caption
        config.paragraphSpacing = 8
        config.alignment = .center
        config.lineHeight = 24
        let label = LOLabel(config: config)
        label.numberOfLines = 10
        return label
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        view.backgroundColor = .black.withAlphaComponent(0.6)
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(contentVStack)
        contentVStack.addArrangedSubview(titleLabel)
        contentVStack.addArrangedSubview(LOSpacer(8))
        contentVStack.addArrangedSubview(descriptionLabel)
        
        contentVStack.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(28)
            $0.centerY.equalToSuperview()
        }
    }
}

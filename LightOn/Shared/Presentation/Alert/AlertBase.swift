//
//  AlertBase.swift
//  LightOn
//
//  Created by 신정욱 on 5/30/25.
//

import UIKit

import SnapKit

class AlertBase: UIViewController {
    
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
        var config = TextConfiguration()
        config.font = .pretendard.bold(22)
        config.foregroundColor = .loBlack
        config.alignment = .center
        config.lineHeight = 28.6
        return TPLabel(config: config)
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
        
        contentVStack.snp.makeConstraints{
            $0.horizontalEdges.equalToSuperview().inset(28)
            $0.centerY.equalTo(view.safeAreaLayoutGuide)
            $0.height.lessThanOrEqualTo(520)
        }
    }
}

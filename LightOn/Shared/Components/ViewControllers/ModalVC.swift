//
//  ModalVC.swift
//  LightOn
//
//  Created by 신정욱 on 7/4/25.
//


import UIKit
import Combine

import CombineCocoa
import SnapKit

class ModalVC: UIViewController {
    
    // MARK: Components
    
    let contentVStack = UIStackView(.vertical, inset: .init(horizontal: 18))
    let titleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.bold(22)
        config.foregroundColor = .loBlack
        config.alignment = .center
        config.lineHeight = 28.6
        return LOLabel(config: config)
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        sheetPresentationController?.preferredCornerRadius = 14 // 모달 모서리 굴곡
        view.backgroundColor = .white
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(contentVStack)
        contentVStack.addArrangedSubview(LOSpacer(28))
        contentVStack.addArrangedSubview(titleLabel)
        contentVStack.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//
//  BackButtonVC.swift
//  LightOn
//
//  Created by 신정욱 on 5/23/25.
//

import UIKit
import Combine

import CombineCocoa

class BackButtonVC: BackableVC {

    // MARK: Components
    
    let backBarButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = .init(vertical: 8)
        config.image = .backBarButtonArrow
        return UIButton(configuration: config)
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        navigationBar.leftItemHStack.addArrangedSubview(LOSpacer(16))
        navigationBar.leftItemHStack.addArrangedSubview(backBarButton)
    }
}

// MARK: Binders & Publishers

extension BackButtonVC {
    /// 뒤로가기 바 버튼 탭
    var backTapPublisher: AnyPublisher<Void, Never> { backBarButton.tapPublisher }
}

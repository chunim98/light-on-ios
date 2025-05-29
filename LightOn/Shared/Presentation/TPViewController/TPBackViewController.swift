//
//  TPBackViewController.swift
//  TennisParkForManager
//
//  Created by 신정욱 on 5/23/25.
//

import UIKit

class TPBackViewController: TPBarViewController {

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
        setupDefaults()
        setupLayout()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        // interactivePopGesture 복구
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        navigationBar.leftItemHStack.addArrangedSubview(backBarButton)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension TPBackViewController: UIGestureRecognizerDelegate {
    /// 제스처가 시작되기 전에 동작 여부를 결정
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool { true }
}

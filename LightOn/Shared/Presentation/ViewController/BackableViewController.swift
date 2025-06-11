//
//  BackableViewController.swift
//  LightOn
//
//  Created by 신정욱 on 5/30/25.
//

import UIKit

class BackableViewController: BarViewController {
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        // interactivePopGesture 복구
        // 화면 이동할 때마다 델리게이트가 덮어씌워지면 안되니까, nil 체크
        if navigationController?.interactivePopGestureRecognizer?.delegate == nil {
            navigationController?.interactivePopGestureRecognizer?.delegate = self
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension BackableViewController: UIGestureRecognizerDelegate {
    /// 제스처가 시작되기 전에 동작 여부를 결정
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool { true }
}

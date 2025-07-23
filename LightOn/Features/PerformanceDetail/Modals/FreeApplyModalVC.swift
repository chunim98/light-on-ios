//
//  FreeApplyModalVC.swift
//  LightOn
//
//  Created by 신정욱 on 7/16/25.
//

import UIKit
import Combine

final class FreeApplyModalVC: PerformanceDetailBaseModalVC {
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        acceptButton.setTitle("신청하기", .pretendard.semiBold(16))
        descriptionLabel.config.text = """
        본 공연은 무료 공연입니다.
        신청 후 마이페이지에서 입장권을\u{2028}확인 하실 수 있습니다.
        """
    }
}

// MARK: - Preview

#Preview { FreeApplyModalVC() }

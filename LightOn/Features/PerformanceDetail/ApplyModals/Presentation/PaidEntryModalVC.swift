//
//  PaidEntryModalVC.swift
//  LightOn
//
//  Created by 신정욱 on 7/24/25.
//

import UIKit
import Combine

final class PaidEntryModalVC: BaseApplyModalVC {
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        acceptButton.setTitle("다음", .pretendard.semiBold(16))
        descriptionLabel.config.text = """
        본 공연은 유료 공연입니다.
        안내드리는 계좌로 입금 확인 후\u{2028}신청이 완료 됩니다.
        """
    }
}

// MARK: - Preview

#Preview { PaidEntryModalVC() }

//
//  AudienceCountPickerModalVC.swift
//  LightOn
//
//  Created by 신정욱 on 7/24/25.
//

import UIKit
import Combine

final class AudienceCountPickerModalVC: BaseApplyModalVC {
    
    // MARK: Components
    
    private let pickerView = AudienceCountPickerView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        acceptButton.setTitle("다음", .pretendard.semiBold(16))
        descriptionLabel.config.text = "예매 희망하는 인원수를 알려주세요"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentVStack.insertArrangedSubview(pickerView, at: 4)
    }
}

// MARK: Binders & Publishers

extension AudienceCountPickerModalVC {
    /// 관객 수 퍼블리셔 (버튼 탭 이벤트와 전달됨)
    var audienceCountPublisher: AnyPublisher<Int, Never> {
        acceptButton.tapPublisher
            .withLatestFrom(pickerView.countPublisher) { _, count in count }
            .eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { AudienceCountPickerModalVC() }

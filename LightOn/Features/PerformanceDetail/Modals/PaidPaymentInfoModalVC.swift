//
//  PaidPaymentInfoModalVC.swift
//  LightOn
//
//  Created by 신정욱 on 7/24/25.
//

import UIKit
import Combine

final class PaidPaymentInfoModalVC: PerformanceDetailBaseModalVC {
    
    // MARK: Properties
    
    private let infoLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(14)
        config.foregroundColor = .caption
        config.paragraphSpacing = 8
        config.lineHeight = 21
        let label = LOPaddingLabel(
            configuration: config,
            padding: .init(horizontal: 12, vertical: 18)
        )
        label.backgroundColor = .background
        label.numberOfLines = .max
        return label
    }()
    
    private let captionLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(14)
        config.foregroundColor = .caption
        config.paragraphSpacing = 4
        config.lineHeight = 20
        config.text = """
        * 반드시 신청자 이름으로 입금 부탁드립니다.
        * 영업일 기준 1~2일정도 소요됩니다.
        * 입금 계좌 정보는 [마이페이지]>[신청 내역]에서 확인하실 수 있습니다.
        """
        let label = LOPaddingLabel(
            configuration: config,
            padding: .init(horizontal: 4)
        )
        label.numberOfLines = .max
        label.addAnyAttribute(
            name: .font,
            value: UIFont.pretendard.bold(14)!,
            segment: "[마이페이지]>[신청 내역]"
        )
        return label
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setPaymentDescription(accountHolder: "아이유", accountNumber: "000-0000-11-323434", amount: 1190000) // temp
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        acceptButton.setTitle("확인", .pretendard.semiBold(16))
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentVStack.insertArrangedSubview(infoLabel, at: 3)
        contentVStack.insertArrangedSubview(LOSpacer(16), at: 4)
        contentVStack.insertArrangedSubview(captionLabel, at: 5)
    }
    
    // MARK: Public Configuration
    
    /// 지불 정보 레이블 구성
    func setPaymentDescription(
        accountHolder: String,
        accountNumber: String,
        amount: Int
    ) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let price = formatter.string(
            from: NSNumber(value: amount)
        ) ?? "\(amount)"
        
        infoLabel.config.text = """
        • 예금주 : \(accountHolder)
        • 계좌번호 : \(accountNumber)
        • 공연 비용 : \(price)원
        """
        
        infoLabel.addAnyAttribute(
            name: .font,
            value: UIFont.pretendard.bold(14)!,
            segment: "공연 비용 : \(price)원"
        )
    }
}

// MARK: - Preview

#Preview { PaidPaymentInfoModalVC() }

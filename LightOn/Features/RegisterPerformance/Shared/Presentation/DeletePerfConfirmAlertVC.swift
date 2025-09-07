//
//  DeletePerfConfirmAlertVC.swift
//  LightOn
//
//  Created by 신정욱 on 8/29/25.
//

import UIKit
import Combine

import CombineCocoa

final class DeletePerfConfirmAlertVC: BaseAlertVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let buttonHStack = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    private let captionLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(14)
        config.foregroundColor = .infoText
        config.alignment = .center
        config.lineHeight = 22
        config.text = "취소일로부터 2일 이내에 환불이 완료되지 않을 경우,\u{2028}법적 조치가 취해질 수 있습니다."
        let label = LOLabel(config: config)
        label.numberOfLines = 0 // 무제한
        return label
    }()
    
    let acceptButton = {
        let button = LOButton(style: .filled)
        button.setTitle("확인", .pretendard.semiBold(16))
        return button
    }()
    
    private let cancelButton = {
        let button = LOButton(style: .bordered)
        button.setTitle("취소", .pretendard.regular(16))
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        titleLabel.config.text = "공연을 취소하시겠습니까?"
        descriptionLabel.config.text = """
        유료 공연의 경우,\u{2028}신청 취소 시 이용자에게 반드시\u{2028}환불 처리를 완료해야 합니다.
        """
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentVStack.addArrangedSubview(LOSpacer(8))
        contentVStack.addArrangedSubview(captionLabel)
        contentVStack.addArrangedSubview(LOSpacer(28))
        contentVStack.addArrangedSubview(buttonHStack)
        
        buttonHStack.addArrangedSubview(cancelButton)
        buttonHStack.addArrangedSubview(acceptButton)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 취소버튼 누르면 화면 닫기
        cancelButton.tapPublisher
            .sink { [weak self] in self?.dismiss(animated: true) }
            .store(in: &cancellables)
    }
}

//
//  EditPerfConfirmAlertVC.swift
//  LightOn
//
//  Created by 신정욱 on 8/23/25.
//

import UIKit
import Combine

import CombineCocoa

final class EditPerfConfirmAlertVC: BaseAlertVC {
    
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
        config.lineHeight = 24.4
        config.text = "심사는 영업일 기준 1~2일 소요 예정"
        return LOLabel(config: config)
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
        titleLabel.config.text = "공연을 수정하시겠습니까?"
        descriptionLabel.config.text = """
        작성하신 내용으로\u{2028}공연을 등록하시겠습니까?
        등록한 공연은 심사 후\u{2028}최종 등록 될 예정입니다.
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
        cancelButton.tapPublisher
            .sink { [weak self] in self?.dismiss(animated: true) }
            .store(in: &cancellables)
    }
}

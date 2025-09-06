//
//  NotArtistAlertVC.swift
//  LightOn
//
//  Created by 신정욱 on 9/7/25.
//

import UIKit

import Combine
import CombineCocoa

final class NotArtistAlertVC: BaseAlertVC {
    
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
        config.text = "심사는 영업일 기준 1~2일 소요 예정"
        let label = LOLabel(config: config)
        label.numberOfLines = 0 // 무제한
        return label
    }()
    
    private let acceptButton = {
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
        titleLabel.config.text = "아티스트 회원이 아닙니다"
        descriptionLabel.config.text = """
        일반 공연은 아티스트 회원만\u{2028}등록할 수 있습니다.
        아티스트 회원 신청을 진행하시겠습니까?
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

// MARK: Binders & Publishers

extension NotArtistAlertVC {
    /// 확인 탭 퍼블리셔
    /// - 얼럿이 닫히고 나서 이벤트 방출
    var acceptTapPublisher: AnyPublisher<Void, Never> {
        acceptButton.tapPublisher.flatMap {
            Future { [weak self] promise in
                self?.dismiss(animated: true) { promise(.success(())) }
            }
        }
        .eraseToAnyPublisher()
    }
}

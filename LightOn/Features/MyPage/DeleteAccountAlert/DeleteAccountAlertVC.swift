//
//  DeleteAccountAlertVC.swift
//  LightOn
//
//  Created by 신정욱 on 8/19/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class DeleteAccountAlertVC: BaseAlertVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = MyPageDI.shared.makeDeleteAccountAlertVM()
    
    // MARK: Subjects
    
    /// 회원탈퇴 완료 서브젝트
    private let accountDeletedSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Components
    
    private let buttonsHStack = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    private let cancelButton = {
        let button = LOButton(style: .bordered)
        button.setTitle("취소", .pretendard.regular(16))
        return button
    }()
    
    private let acceptButton = {
        let button = LOButton(style: .filled)
        button.setTitle("확인", .pretendard.semiBold(16))
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
        titleLabel.config.text = "회원 탈퇴"
        descriptionLabel.config.text = """
        탈퇴 후 기존 저장된 데이터는\u{2028}복구가 되지 않습니다.
        회원탈퇴를 진행하시겠습니까?
        """
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentVStack.addArrangedSubview(LOSpacer(28))
        contentVStack.addArrangedSubview(buttonsHStack)
        
        buttonsHStack.addArrangedSubview(cancelButton)
        buttonsHStack.addArrangedSubview(acceptButton)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let input = DeleteAccountAlertVM.Input(trigger: acceptButton.tapPublisher)
        let output = vm.transform(input)
        
        // 회원탈퇴 완료 이벤트 외부로 방출
        output.accountDeleted
            .sink { [weak self] in self?.accountDeletedSubject.send(()) }
            .store(in: &cancellables)
        
        // 취소 버튼을 누르거나 회원탈퇴가 끝나면 얼럿 닫기
        Publishers
            .Merge(cancelButton.tapPublisher, output.accountDeleted)
            .sink { [weak self] in self?.dismiss(animated: true) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension DeleteAccountAlertVC {
    /// 회원탈퇴 완료 퍼블리셔
    var accountDeletedPublisher: AnyPublisher<Void, Never> {
        accountDeletedSubject.eraseToAnyPublisher()
    }
}

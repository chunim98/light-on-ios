//
//  CancelApplicationModalVC.swift
//  LightOn
//
//  Created by 신정욱 on 9/3/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class CancelApplicationModalVC: BaseAlertVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm: CancelApplicationModalVM
    
    // MARK: Subjects
    
    /// 공연신청 취소 완료 서브젝트(출력)
    private let applicationCancelledSubject = PassthroughSubject<Void, Never>()
    
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
        config.text = "환불은 취소일로 부터 2~3일 소요 예정"
        return LOLabel(config: config)
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
    
    init(vm: CancelApplicationModalVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        titleLabel.config.text = "신청을 취소하시겠습니까?"
        descriptionLabel.config.text = """
        신청하신 공연을
        취소하시겠습니까?
        
        티켓 비용은 환불 절차에
        따라 진행될 예정입니다.
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
        let input = CancelApplicationModalVM.Input(acceptTap: acceptButton.tapPublisher)
        let output = vm.transform(input)
        
        // 공연신청 취소 완료 외부로 방출
        output.applicationCancelled
            .sink(receiveValue: applicationCancelledSubject.send(_:))
            .store(in: &cancellables)
        
        // 닫기 탭하면, 화면 닫기
        cancelButton.tapPublisher
            .sink { [weak self] in self?.dismiss(animated: true) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension CancelApplicationModalVC {
    /// 공연신청 취소 완료 퍼블리셔
    /// - dismiss 애니메이션까지 완료하고 외부로 방출
    var applicationCancelledPublisher: AnyPublisher<Void, Never> {
        applicationCancelledSubject
            .map { [weak self] in
                Future<Void, Never> { promise in
                    self?.dismiss(animated: true) { promise(.success(())) }
                }
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
}

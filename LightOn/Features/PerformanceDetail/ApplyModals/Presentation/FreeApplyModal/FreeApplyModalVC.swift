//
//  FreeApplyModalVC.swift
//  LightOn
//
//  Created by 신정욱 on 7/16/25.
//

import UIKit
import Combine

import CombineCocoa

final class FreeApplyModalVC: BaseApplyModalVC {
    
    // MARK: Properties
    
    private let vm: FreeApplyModalVM
    
    // MARK: Outputs
    
    /// 공연 신청 완료 이벤트 서브젝트
    private let applicationCompleteEventSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Life Cycle
    
    init(vm: FreeApplyModalVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        acceptButton.setTitle("신청하기", .pretendard.semiBold(16))
        descriptionLabel.config.text = """
        본 공연은 무료 공연입니다.
        신청 후 마이페이지에서 입장권을\u{2028}확인 하실 수 있습니다.
        """
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let input = FreeApplyModalVM.Input(confirmTap: acceptButton.tapPublisher)
        let output = vm.transform(input)
        
        output.applicationCompleteEvent
            .sink { [weak self] in self?.applicationCompleteEventSubject.send(()) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension FreeApplyModalVC {
    /// 공연 신청 완료 이벤트 퍼블리셔
    var applicationCompleteEventPublisher: AnyPublisher<Void, Never> {
        applicationCompleteEventSubject.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview {
    let vm = PerformanceDetailDI.shared.makeFreeApplyModalVM(
        performanceID: -1
    )
    return FreeApplyModalVC(vm: vm)
}

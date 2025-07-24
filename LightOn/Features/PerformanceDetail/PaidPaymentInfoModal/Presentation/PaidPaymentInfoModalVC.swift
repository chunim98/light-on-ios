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
    
    private let vm: PaidPaymentInfoModalVM
    
    // MARK: Outputs
    
    /// 공연 신청 완료 이벤트 서브젝트
    private let applicationCompleteEventSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Components
    
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
    
    init(vm: PaidPaymentInfoModalVM) {
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
        acceptButton.setTitle("확인", .pretendard.semiBold(16))
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentVStack.insertArrangedSubview(infoLabel, at: 3)
        contentVStack.insertArrangedSubview(LOSpacer(16), at: 4)
        contentVStack.insertArrangedSubview(captionLabel, at: 5)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let input = PaidPaymentInfoModalVM.Input(
            confirmTap: acceptButton.tapPublisher
        )
        
        let output = vm.transform(input)
        
        output.paymentInfo
            .sink { [weak self] in self?.bindPaymentInfo($0) }
            .store(in: &cancellables)
        
        output.applicationCompleteEvent
            .sink { [weak self] in self?.applicationCompleteEventSubject.send(()) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension PaidPaymentInfoModalVC {
    /// 지불 정보 바인딩
    private func bindPaymentInfo(_ info: PaymentInfo) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let price = formatter.string(
            from: NSNumber(value: info.amount)
        ) ?? "\(info.amount)"
        
        let holder = info.accountHolder ?? ""
        let number = info.accountNumber ?? ""
        let bank = info.bank.map { "(\($0))" } ?? ""
        
        infoLabel.config.text = """
        • 예금주 : \(holder)
        • 계좌번호 : \(number)\(bank)
        • 공연 비용 : \(price)원
        """
        
        infoLabel.addAnyAttribute(
            name: .font,
            value: UIFont.pretendard.bold(14)!,
            segment: "공연 비용 : \(price)원"
        )
    }
    
    /// 공연 신청 완료 이벤트 퍼블리셔
    var applicationCompleteEventPublisher: AnyPublisher<Void, Never> {
        applicationCompleteEventSubject.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview {
    let vm = PerformanceDetailDI.shared.makePaidPaymentInfoModalVM(
        performanceID: -1,
        audienceCount: 1
    )
    return PaidPaymentInfoModalVC(vm: vm)
}


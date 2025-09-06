//
//  RegisterConcertVC.swift
//  LightOn
//
//  Created by 신정욱 on 7/4/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class RegisterConcertVC: BaseRegisterPerfVC {
    
    // MARK: Properties
    
    private let vm = RegisterPerformanceDI.shared.makeRegisterConcertVM()
    
    // MARK: Subjects
    
    /// 공연 등록 완료 서브젝트
    private let registerCompleteSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Components
    
    /// 공연 등록 전 확인 얼럿
    private let confirmAlert = RegisterConcertConfirmAlertVC()
    
    private let checkboxHStack = UIStackView(spacing: 18)
    
    private let seatTitleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.semiBold(16)
        config.foregroundColor = .loBlack
        config.text = "좌석 정보"
        return LOLabel(config: config)
    }()
    
    /// 결제 여부 및 결제 정보 폼 컨테이너
    private let paymentContainer = PaymentFormContainerView()
    
    /// 좌석수 폼
    private let seatCountForm = {
        let form = TextForm()
        form.textField.keyboardType = .numberPad
        form.textField.setPlaceHolder("예매 가능한 좌석수를 입력해주세요")
        form.titleLabel.config.text = "좌석수"
        return form
    }()
    
    // MARK: Buttons
    
    /// 공연 등록 버튼
    private let confirmButton = {
        let button = LOButton(style: .filled)
        button.setTitle("등록하기", .pretendard.bold(16))
        return button
    }()
    
    private let standingCheckbox = {
        let button = Checkbox()
        button.titleConfig.text = "스탠딩석"
        return button
    }()
    
    private let freestyleCheckbox = {
        let button = Checkbox()
        button.titleConfig.text = "자율좌석"
        return button
    }()
    
    private let assignedCheckbox = {
        let button = Checkbox()
        button.titleConfig.text = "지정좌석"
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentVStack.insertArrangedSubview(LOSpacer(24),   at: 12)
        contentVStack.insertArrangedSubview(paymentContainer, at: 13)
        
        contentVStack.insertArrangedSubview(LOSpacer(20),   at: 23)
        contentVStack.insertArrangedSubview(seatTitleLabel, at: 24)
        contentVStack.insertArrangedSubview(LOSpacer(16),   at: 25)
        contentVStack.insertArrangedSubview(seatCountForm,  at: 26)
        contentVStack.insertArrangedSubview(LOSpacer(20),   at: 27)
        contentVStack.insertArrangedSubview(checkboxHStack, at: 28)
        contentVStack.insertArrangedSubview(LOSpacer(40),   at: 29)
        contentVStack.addArrangedSubview(confirmButton)
        
        checkboxHStack.addArrangedSubview(standingCheckbox)
        checkboxHStack.addArrangedSubview(freestyleCheckbox)
        checkboxHStack.addArrangedSubview(assignedCheckbox)
        checkboxHStack.addArrangedSubview(LOSpacer())
        
        // 오버레이 뷰 레이아웃
        paymentContainer.accountForm.bankDropdown.setupOverlayLayout(superView: contentVStack)
        
        contentVStack.bringSubviewToFront(genreForm.dropdown.tableContainer)
        contentVStack.bringSubviewToFront(paymentContainer.accountForm.bankDropdown.tableContainer)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        /// 스탠딩석 체크 여부
        /// - 초기값 nil, 체크 상태가 아니면 nil
        let standing = standingCheckbox.isSelectedPublisher
            .map { $0 ? RegisterConcertInfo.SeatType.standing : nil }
            .prepend(nil) // 초기값 필요
            .eraseToAnyPublisher()
        
        /// 자율좌석 체크 여부
        /// - 초기값 nil, 체크 상태가 아니면 nil
        let freestyle = freestyleCheckbox.isSelectedPublisher
            .map { $0 ? RegisterConcertInfo.SeatType.freestyle : nil }
            .prepend(nil) // 초기값 필요
            .eraseToAnyPublisher()
        
        /// 지정좌석 체크 여부
        /// - 초기값 nil, 체크 상태가 아니면 nil
        let assigned = assignedCheckbox.isSelectedPublisher
            .map { $0 ? RegisterConcertInfo.SeatType.assigned : nil }
            .prepend(nil) // 초기값 필요
            .eraseToAnyPublisher()
        
        /// 좌석 타입 배열
        /// - nil인 좌석들은 배열에서 제외
        let seatTypes = Publishers.CombineLatest3(standing, freestyle, assigned)
            .map { [$0.0, $0.1, $0.2].compactMap { $0 } }
            .eraseToAnyPublisher()
        
        /// 좌석 수
        /// - String? 타입을 Int타입으로 변환
        let totalSeatsCount = seatCountForm.textPublisher
            .map { $0.flatMap { Int($0) } }
            .eraseToAnyPublisher()
        
        /// 가격
        /// - String? 타입을 Int타입으로 변환
        let price = paymentContainer.priceForm.textPublisher
            .map { $0.flatMap { Int($0) } }
            .eraseToAnyPublisher()
        
        /// 계좌 번호
        let accountNumber = paymentContainer.accountForm.accountNumberTextField.textPublisher
            .map { $0.flatMap { $0.isEmpty ? nil : $0 } }
            .eraseToAnyPublisher()
        
        /// 은행명
        let bank = paymentContainer.accountForm.bankDropdown.selectedItemPublisher
            .map { $0?.title }
            .eraseToAnyPublisher()
        
        /// 예금주명
        let accountHolder = paymentContainer.accountForm.accountHolderTextField.textPublisher
            .map { $0.flatMap { $0.isEmpty ? nil : $0 } }
            .eraseToAnyPublisher()
        
        let input = RegisterConcertVM.Input(
            title: nameForm.validTextPublisher,
            description: descriptionForm.validTextPublisher,
            regionID: addressForm.regionIDPublisher,
            place: addressForm.detailAddressPublisher,
            notice: noticeForm.textPublisher,
            genre: genreForm.genrePublisher,
            startDate: scheduleFormVC.datePickerFormCompVC.startDatePublisher,
            endDate: scheduleFormVC.datePickerFormCompVC.endDatePublisher,
            startTime: scheduleFormVC.timePickerFormCompVC.startModalVC.timePublisher,
            endTime: scheduleFormVC.timePickerFormCompVC.endModalVC.timePublisher,
            isPaid: paymentContainer.paymentTypeForm.isPaidPublisher,
            price: price,
            account: accountNumber,
            bank: bank,
            accountHolder: accountHolder,
            seatTypes: seatTypes,
            totalSeatsCount: totalSeatsCount,
            posterInfo: posterUploadFormVC.imageInfoPublisher,
            documentInfo: documentUploadFormVC.imageInfoPublisher,
            alertConfirmTap: confirmAlert.acceptButton.tapPublisher
        )
        
        let output = vm.transform(input)
        
        // 아티스트 정보 초기값을 컴포넌트에 할당
        output.initialArtistInfo
            .sink { [weak self] in self?.assignInitialValues(with: $0) }
            .store(in: &cancellables)
        
        // 모든 필드가 채워지면 등록버튼 활성화
        output.allValuesValid
            .sink { [weak self] in self?.confirmButton.isEnabled = $0 }
            .store(in: &cancellables)
        
        // 공연 등록 완료 이벤트 외부로 전달
        output.registerCompleteEvent
            .sink(receiveValue: registerCompleteSubject.send(_:))
            .store(in: &cancellables)
        
        // 공연등록 확인 얼럿 띄우기
        confirmButton.tapPublisher
            .sink { [weak self] in self?.presentConfirmAlert() }
            .store(in: &cancellables)
        
        // 배경을 터치하면, 오버레이 닫기
        contentVStack.tapPublisher
            .sink { [weak self] in self?.dismissOverlay(gesture: $0) }
            .store(in: &cancellables)
        
        // 닫기버튼 탭 또는 공연 등록 완료 시, 얼럿 닫기
        Publishers.Merge(
            confirmAlert.cancelButton.tapPublisher,
            output.registerCompleteEvent
        )
        .sink { [weak self] in
            self?.confirmAlert.dismiss(animated: true)
        }
        .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension RegisterConcertVC {
    /// 아티스트 정보 초기값을 컴포넌트에 할당
    private func assignInitialValues(with info: ArtistInfo) {
        artistNameForm.textField.text = info.artistName
        artistDescriptionForm.textView.text = info.artistDescription
    }
    
    /// 배경을 터치하면, 오버레이 닫기
    private func dismissOverlay(gesture: UITapGestureRecognizer) {
        paymentContainer.accountForm.bankDropdown.dismissTable(gesture)
    }
    
    /// 공연등록 확인 얼럿 띄우기
    private func presentConfirmAlert() {
        confirmAlert.modalPresentationStyle = .overFullScreen
        confirmAlert.modalTransitionStyle = .crossDissolve
        present(confirmAlert, animated: true)
    }
    
    /// 공연 등록 완료 이벤트 퍼블리셔
    var registerCompletePublisher: AnyPublisher<Void, Never> {
        registerCompleteSubject.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { RegisterConcertVC() }

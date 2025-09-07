//
//  ModifyConcertVC.swift
//  LightOn
//
//  Created by 신정욱 on 9/6/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class ModifyConcertVC: BaseRegisterConcertVC {
    
    // MARK: Properties
    
    private let vm: ModifyConcertVM
    
    // MARK: Subjects
    
    /// 콘서트 수정 및 삭제 완료 서브젝트(출력용)
    private let editOrDeleteCompletedSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Components
    
    /// 콘서트 수정 확인 얼럿
    private let editConfirmAlert = EditPerfConfirmAlertVC()
    /// 콘서트 삭제 확인 얼럿
    private let deleteConfirmAlert = DeletePerfConfirmAlertVC()
    
    private let buttonsHStack = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    /// 콘서트 취소 버튼
    private let deleteButton = {
        let button = LOButton(style: .borderedTinted)
        button.setTitle("취소하기", .pretendard.bold(16))
        return button
    }()
    
    /// 수정 완료 버튼
    private let confirmButton = {
        let button = LOButton(style: .filled)
        button.setTitle("수정하기", .pretendard.bold(16))
        return button
    }()
    
    // MARK: Life Cycle
    
    init(vm: ModifyConcertVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentVStack.addArrangedSubview(LOSpacer(40))
        contentVStack.addArrangedSubview(buttonsHStack)
        
        buttonsHStack.addArrangedSubview(deleteButton)
        buttonsHStack.addArrangedSubview(confirmButton)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
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
        
        let input = ModifyConcertVM.Input(
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
            isStanding: standingCheckbox.isSelectedPublisher,
            isFreestyle: freestyleCheckbox.isSelectedPublisher,
            isAssigned: assignedCheckbox.isSelectedPublisher,
            totalSeatsCount: totalSeatsCount,
            posterInfo: posterUploadFormVC.imageInfoPublisher,
            documentInfo: documentUploadFormVC.imageInfoPublisher,
            editConfirmTap: editConfirmAlert.acceptButton.tapPublisher,
            deleteConfirmTap: deleteConfirmAlert.acceptButton.tapPublisher
        )
        
        let output = vm.transform(input)
        
        // 최초 로드 시 콘서트 정보 바인딩
        output.initialInfo
            .sink { [weak self] in self?.updateUI(with: $0) }
            .store(in: &cancellables)
        
        // 수정 완료 시, 화면닫고 외부로 이벤트 방출
        output.editComplete
            .sink { [weak self] in
                self?.editConfirmAlert.dismiss(animated: true) {
                    self?.editOrDeleteCompletedSubject.send(())
                }
            }
            .store(in: &cancellables)
        
        // 삭제 완료 시, 화면닫고 외부로 이벤트 방출
        output.deleteComplete
            .sink { [weak self] in
                self?.deleteConfirmAlert.dismiss(animated: true) {
                    self?.editOrDeleteCompletedSubject.send(())
                }
            }
            .store(in: &cancellables)
        
        // 시작 3일 전이고, 모든 필드가 채워지면 수정 버튼 활성화
        output.buskingEditable
            .sink { [weak self] in self?.confirmButton.isEnabled = $0 }
            .store(in: &cancellables)
        
        // 시작 1시간 전이면 삭제 버튼 활성화
        output.buskingCancellable
            .sink { [weak self] in self?.deleteButton.isEnabled = $0 }
            .store(in: &cancellables)
        
        // 수정하기 버튼 누르면 확인 얼럿 띄우기
        confirmButton.tapPublisher
            .sink { [weak self] in self?.presentEditConfirmAlert() }
            .store(in: &cancellables)
        
        // 삭제하기 버튼 누르면 확인 얼럿 띄우기
        deleteButton.tapPublisher
            .sink { [weak self] in self?.presentDeleteConfirmAlert() }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension ModifyConcertVC {
    /// RegisterConcertInfo의 데이터를 각 UI 컴포넌트에 바인딩
    private func updateUI(with info: ConcertInfo) {
        // 기본 정보
        nameForm.textView.text = info.title
        descriptionForm.textView.text = info.description
        noticeForm.textField.text = info.notice
        
        // 유료 전용 필드 활성/비활성
        paymentContainer.paymentTypeForm.radioControll.selectIndex(info.isPaid ? 1 : 0)
        paymentContainer.priceForm.isHidden = !info.isPaid
        paymentContainer.accountForm.isHidden = !info.isPaid
        
        // 결제 정보
        if info.isPaid, let bank = info.bank {
            paymentContainer.accountForm.bankDropdown.selectItem(.init(title: bank))
            paymentContainer.accountForm.accountHolderTextField.text = info.accountHolder
            paymentContainer.accountForm.accountNumberTextField.text = info.account
            paymentContainer.priceForm.textField.text = info.price.map { String($0) }
        }
        
        // 좌석 정보
        seatCountForm.textField.text = info.totalSeatsCount.map { String($0) }
        standingCheckbox.isSelected = info.isStanding
        freestyleCheckbox.isSelected = info.isFreestyle
        assignedCheckbox.isSelected = info.isAssigned
        
        // 아티스트 정보
        artistNameForm.textField.text = info.artistName
        artistDescriptionForm.textView.text = info.artistDescription
        
        // 장소 정보
        addressForm.setRegionID(info.regionID)
        addressForm.textField.text = info.place
        
        // 일정 정보
        scheduleFormVC.datePickerFormCompVC.setDates(start: info.startDate, end: info.endDate)
        scheduleFormVC.timePickerFormCompVC.updateStartTime(info.startTime)
        scheduleFormVC.timePickerFormCompVC.updateEndTime(info.endTime)
        
        // 장르
        genreForm.selectGenre(info.genre)
        
        // 첨부 파일
        posterUploadFormVC.baseForm.textField.text = info.posterInfo?.name
        documentUploadFormVC.baseForm.textField.text = info.documentInfo?.name
    }
    
    /// 콘서트 수정 확인 얼럿 띄우기
    private func presentEditConfirmAlert() {
        editConfirmAlert.modalPresentationStyle = .overFullScreen
        editConfirmAlert.modalTransitionStyle = .crossDissolve
        present(editConfirmAlert, animated: true)
    }
    
    /// 콘서트 삭제 확인 얼럿 띄우기
    private func presentDeleteConfirmAlert() {
        deleteConfirmAlert.modalPresentationStyle = .overFullScreen
        deleteConfirmAlert.modalTransitionStyle = .crossDissolve
        present(deleteConfirmAlert, animated: true)
    }
    
    /// 콘서트 수정 및 삭제 완료 이벤트
    var editOrDeleteCompletedPublisher: AnyPublisher<Void, Never> {
        editOrDeleteCompletedSubject.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { ModifyBuskingVC(vm: RegisterPerformanceDI.shared.makeModifyBuskingVM(id: 62)) }

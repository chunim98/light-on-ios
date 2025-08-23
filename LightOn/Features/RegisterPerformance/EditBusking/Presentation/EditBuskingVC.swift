//
//  EditBuskingVC.swift
//  LightOn
//
//  Created by 신정욱 on 8/20/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class EditBuskingVC: BaseRegisterPerfVC {
    
    // MARK: Properties
    
    private let vm: EditBuskingVM
    
    // MARK: Subjects
    
    /// 공연 수정 완료 서브젝트(출력용)
    private let editCompleteSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Components
    
    /// 공연 수정 확인 얼럿
    private let editConfirmAlert = EditBuskingConfirmAlertVC()
    
    private let buttonsHStack = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    /// 공연 취소 버튼
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
    
    init(vm: EditBuskingVM) {
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
        let input = EditBuskingVM.Input(
            name:               nameForm.validTextPublisher,
            description:        descriptionForm.validTextPublisher,
            regionID:           addressForm.regionIDPublisher,
            detailAddress:      addressForm.detailAddressPublisher,
            notice:             noticeForm.textPublisher,
            genre:              genreForm.genrePublisher,
            posterInfo:         posterUploadFormVC.imageInfoPublisher,
            startDate:          scheduleFormVC.startDatePublisher,
            endDate:            scheduleFormVC.endDatePublisher,
            startTime:          scheduleFormVC.startTimePublisher,
            endTime:            scheduleFormVC.endTimePublisher,
            documentInfo:       documentUploadFormVC.imageInfoPublisher,
            artistName:         artistNameForm.validTextPublisher,
            artistDescription:  artistDescriptionForm.validTextPublisher,
            editConfirmTap:     editConfirmAlert.acceptButton.tapPublisher
        )
        
        let output = vm.transform(input)
        
        output.initialInfo
            .sink { [weak self] in self?.updateUI(with: $0) }
            .store(in: &cancellables)
        
        output.allValuesValid
            .sink { [weak self] in self?.confirmButton.isEnabled = $0 }
            .store(in: &cancellables)
        
        output.editComplete
            .sink { [weak self] in
                self?.editConfirmAlert.dismiss(animated: true) {
                    self?.editCompleteSubject.send(())
                }
            }
            .store(in: &cancellables)
        
        // 수정하기 버튼 누르면 확인 얼럿 띄우기
        confirmButton.tapPublisher
            .sink { [weak self] in self?.presentEditConfirmAlert() }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension EditBuskingVC {
    /// RegisterBuskingInfo의 데이터를 각 UI 컴포넌트에 바인딩
    private func updateUI(with info: BuskingInfo) {
        // 기본 정보
        nameForm.textView.text = info.name
        descriptionForm.textView.text = info.description
        noticeForm.textField.text = info.notice
        
        // 아티스트 정보
        artistNameForm.textField.text = info.artistName
        artistDescriptionForm.textView.text = info.artistDescription
        
        // 장소 정보
        addressForm.setRegionID(info.regionID)
        addressForm.textField.text = info.detailAddress
        
        // 일정 정보
        scheduleFormVC.updateDateRange(DateRange(
            start: info.startDate,
            end: info.endDate
        ))
        scheduleFormVC.updateStartTime(info.startTime)
        scheduleFormVC.updateEndTime(info.endTime)
        
        // 장르
        genreForm.selectGenre(info.genre)
        
        // 첨부 파일
        posterUploadFormVC.baseForm.textField.text = info.posterInfo?.name
        documentUploadFormVC.baseForm.textField.text = info.documentInfo?.name
    }
    
    /// 공연수정 확인 얼럿 띄우기
    private func presentEditConfirmAlert() {
        editConfirmAlert.modalPresentationStyle = .overFullScreen
        editConfirmAlert.modalTransitionStyle = .crossDissolve
        present(editConfirmAlert, animated: true)
    }
    
    /// 버스킹 수정 완료 이벤트
    var editCompletePublisher: AnyPublisher<Void, Never> {
        editCompleteSubject.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { EditBuskingVC(vm: RegisterPerformanceDI.shared.makeEditBuskingVM(id: 62)) }

//
//  RegisterBuskingVC.swift
//  LightOn
//
//  Created by 신정욱 on 7/14/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class RegisterBuskingVC: BaseRegisterPerfVC {
    
    // MARK: Properties
    
    private let vm = RegisterPerformanceDI.shared.makeRegisterBuskingVM()
    
    // MARK: Subjects
    
    /// 공연 등록 완료 서브젝트
    private let registerCompleteSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Components
    
    /// 공연 등록 전 확인 얼럿
    private let confirmAlert = RegisterBuskingConfirmAlertVC()
    
    /// 공연 등록 버튼
    private let confirmButton = {
        let button = LOButton(style: .filled)
        button.setTitle("등록하기", .pretendard.bold(16))
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Layout
    
    private func setupLayout() { contentVStack.addArrangedSubview(confirmButton) }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let input = RegisterBuskingVM.Input(
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
            alertConfirmTap:    confirmAlert.acceptButton.tapPublisher
        )
        
        let output = vm.transform(input)
        
        // 모든 필드가 채워지면 등록버튼 활성화
        output.allValuesValid
            .sink { [weak self] in self?.confirmButton.isEnabled = $0 }
            .store(in: &cancellables)
        
        // 공연 등록 완료 이벤트 외부로 전달
        output.registerCompleteEvent
            .sink { [weak self] in self?.registerCompleteSubject.send(()) }
            .store(in: &cancellables)
        
        // 공연등록 확인 얼럿 띄우기
        confirmButton.tapPublisher
            .sink { [weak self] in self?.presentConfirmAlert() }
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

extension RegisterBuskingVC {
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

#Preview { RegisterBuskingVC() }

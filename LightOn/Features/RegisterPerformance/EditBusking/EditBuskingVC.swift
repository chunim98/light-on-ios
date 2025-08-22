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
    
    // MARK: Components
    
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
            alertConfirmTap:    Empty().eraseToAnyPublisher()
        )
        
        let output = vm.transform(input)
        
        output.initialInfo
            .sink { [weak self] in self?.setUIValues(with: $0) }
            .store(in: &cancellables)
        
        output.allValuesValid
            .sink { [weak self] in self?.confirmButton.isEnabled = $0 }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension EditBuskingVC {
    private func setUIValues(with info: RegisterBuskingInfo) {
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
}

// MARK: - Preview

#Preview { EditBuskingVC(vm: RegisterPerformanceDI.shared.makeEditBuskingVM(id: 62)) }

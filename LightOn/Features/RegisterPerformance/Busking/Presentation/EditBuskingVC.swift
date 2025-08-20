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
    
    private let vm = RegisterPerformanceDI.shared.makeRegisterBuskingVM()
    
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
        let input = RegisterBuskingVM.Input(
            name:               nameForm.validTextPublisher,
            description:        descriptionForm.validTextPublisher,
            regionID:           addressForm.regionIDPublisher,
            detailAddress:      addressForm.detailAddressPublisher,
            notice:             noticeForm.textPublisher,
            genre:              genreForm.genrePublisher,
            posterInfo:         posterUploadForm.imageInfoPublisher,
            startDate:          scheduleForm.startDatePublisher,
            endDate:            scheduleForm.endDatePublisher,
            startTime:          scheduleForm.startTimePublisher,
            endTime:            scheduleForm.endTimePublisher,
            documentInfo:       documentUploadForm.imageInfoPublisher,
            artistName:         artistNameForm.validTextPublisher,
            artistDescription:  artistDescriptionForm.validTextPublisher,
            alertConfirmTap:    Empty().eraseToAnyPublisher()
        )
        
        let output = vm.transform(input)
    }
}

// MARK: Binders & Publishers

extension EditBuskingVC {}

// MARK: - Preview

#Preview { EditBuskingVC() }

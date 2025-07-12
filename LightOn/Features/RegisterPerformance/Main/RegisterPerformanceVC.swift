//
//  RegisterPerformanceVC.swift
//  LightOn
//
//  Created by 신정욱 on 7/4/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class RegisterPerformanceVC: BackButtonVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let scrollView = UIScrollView()
    private let contentVStack = TapStackView(.vertical, inset: .init(horizontal: 18))
    
    private let performanceInfoTitleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.semiBold(16)
        config.foregroundColor = .loBlack
        config.text = "공연 정보"
        return LOLabel(config: config)
    }()
    
    private let nameForm = {
        let form = CounterMultilineTextForm(maxByte: 50)
        form.textView.setPlaceHolder("공연명을 입력해주세요 (50자 이내)")
        form.titleLabel.config.text = "공연명"
        return form
    }()
    
    private let scheduleForm = ScheduleForm()
    
    private let addressForm = {
        let form = AddressForm()
        form.titleLabel.config.text = "공연 장소"
        form.textField.setPlaceHolder("상세주소")
        return form
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
        navigationBar.titleLabel.config.text = "공연 등록"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentVStack)
        
        contentVStack.addArrangedSubview(LOSpacer(20))
        contentVStack.addArrangedSubview(performanceInfoTitleLabel)
        contentVStack.addArrangedSubview(LOSpacer(16))
        contentVStack.addArrangedSubview(nameForm)
        contentVStack.addArrangedSubview(LOSpacer(24))
        contentVStack.addArrangedSubview(scheduleForm)
        contentVStack.addArrangedSubview(LOSpacer(24))
        contentVStack.addArrangedSubview(addressForm)
        contentVStack.addArrangedSubview(LOSpacer(24))
        
        scrollView.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
        contentVStack.snp.makeConstraints { $0.edges.width.equalToSuperview() }
        
        // 오버레이 뷰 레이아웃
        addressForm.provinceDropdown.setupOverlayLayout(superView: contentVStack)
        addressForm.cityDropdown.setupOverlayLayout(superView: contentVStack)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        contentVStack.tapPublisher
            .sink { [weak self] in self?.bindDismissOverlay(gesture: $0) }
            .store(in: &cancellables)
        
        Publishers.Merge(
            scheduleForm.startDateButton.tapPublisher,
            scheduleForm.endDateButton.tapPublisher
        )
        .sink { [weak self] in self?.bindShowDatePickerModal() }
        .store(in: &cancellables)
        
        scheduleForm.startTimeButton.tapPublisher
            .sink { [weak self] in self?.bindShowStartTimePickerModalVC() }
            .store(in: &cancellables)
        
        scheduleForm.endTimeButton.tapPublisher
            .sink { [weak self] in self?.bindShowEndTimePickerModalVC() }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension RegisterPerformanceVC {
    /// 배경을 터치하면, 오버레이 닫기 (키보드 포함)
    private func bindDismissOverlay(gesture: UITapGestureRecognizer) {
        addressForm.provinceDropdown.bindDismissTable(gesture)
        addressForm.cityDropdown.bindDismissTable(gesture)
        view.endEditing(true)   // 키보드 닫기
    }
    
    /// 날짜 피커 모달 표시
    private func bindShowDatePickerModal() {
        let vc = scheduleForm.datePickerModalVC
        vc.sheetPresentationController?.detents = [.custom { _ in 464.6 }]  // 사전 계산한 모달 높이
        present(vc, animated: true)
    }
    
    /// 시작 시간 피커 모달 표시
    private func bindShowStartTimePickerModalVC() {
        let vc = scheduleForm.startTimePickerModalVC
        vc.sheetPresentationController?.detents = [.custom { _ in 256.6 }]  // 사전 계산한 모달 높이
        present(vc, animated: true)
    }
    
    /// 종료 시간 피커 모달 표시
    private func bindShowEndTimePickerModalVC() {
        let vc = scheduleForm.endTimePickerModalVC
        vc.sheetPresentationController?.detents = [.custom { _ in 256.6 }]  // 사전 계산한 모달 높이
        present(vc, animated: true)
    }
}

// MARK: - Preview

#Preview { RegisterPerformanceVC() }

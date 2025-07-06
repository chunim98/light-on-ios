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
    
    private let backgroundTapGesture = {
        let gesture = UITapGestureRecognizer()
        gesture.cancelsTouchesInView = false
        return gesture
    }()
    
    private let scrollView = UIScrollView()
    private let contentVStack = UIStackView(.vertical, inset: .init(horizontal: 18))
    
    private let performanceInfoTitleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.semiBold(16)
        config.foregroundColor = .loBlack
        config.text = "공연 정보"
        return LOLabel(config: config)
    }()
    
    private let nameForm = {
        let form = CounterMultiLineTextForm(maxByte: 50)
        form.textView.setPlaceHolder("공연명을 입력해주세요 (50자 이내)")
        form.titleLabel.config.text = "공연명"
        return form
    }()
    
    private let scheduleForm = ScheduleForm()
    
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
        contentVStack.addGestureRecognizer(backgroundTapGesture)
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
        
        scrollView.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
        contentVStack.snp.makeConstraints { $0.edges.width.equalToSuperview() }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        backgroundTapGesture.tapPublisher
            .sink { [weak self] _ in self?.contentVStack.endEditing(true) }
            .store(in: &cancellables)
        
        scheduleForm.startDateButton.tapPublisher
            .sink { _ in
                self.scheduleForm.datePickerModalVC.sheetPresentationController?.detents = [.custom { _ in 464.6 }] // 사전 계산한 모달 높이
                self.present(self.scheduleForm.datePickerModalVC, animated: true)
            }
            .store(in: &cancellables)
        
        scheduleForm.startTimeButton.tapPublisher
            .sink { _ in
                self.scheduleForm.startTimePickerModalVC.sheetPresentationController?.detents = [.custom { _ in 256.6 }] // 사전 계산한 모달 높이
                self.present(self.scheduleForm.startTimePickerModalVC, animated: true)
            }
            .store(in: &cancellables)
        
        scheduleForm.endTimeButton.tapPublisher
            .sink { _ in
                self.scheduleForm.endTimePickerModalVC.sheetPresentationController?.detents = [.custom { _ in 256.6 }] // 사전 계산한 모달 높이
                self.present(self.scheduleForm.endTimePickerModalVC, animated: true)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Preview

#Preview { RegisterPerformanceVC() }

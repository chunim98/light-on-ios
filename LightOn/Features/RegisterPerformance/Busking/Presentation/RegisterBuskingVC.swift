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

final class RegisterBuskingVC: BackButtonVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = RegisterBuskingVM()
    
    // MARK: Components
    
    private let scrollView = ResponsiveScrollView()
    private let contentVStack = TapStackView(.vertical, inset: .init(horizontal: 18))
    
    private let confirmButton = {
        let button = LOButton(style: .filled)
        button.setTitle("등록하기", .pretendard.bold(16))
        return button
    }()
    
    private let performanceInfoTitleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.semiBold(16)
        config.foregroundColor = .loBlack
        config.text = "공연 정보"
        return LOLabel(config: config)
    }()
    
    private let atristInfoTitleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.semiBold(16)
        config.foregroundColor = .loBlack
        config.text = "아티스트 정보"
        return LOLabel(config: config)
    }()
    
    private let noticeTitleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.semiBold(16)
        config.foregroundColor = .loBlack
        config.text = "입장 시 유의사항"
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
    
    private let genreForm = GenreForm()
    
    private let descriptionForm = {
        let form = CounterMultilineTextForm(maxByte: 500)
        form.textView.setPlaceHolder("공연 소개 내용을 작성해 주세요 (500자 이내)")
        form.titleLabel.config.text = "공연 소개"
        return form
    }()
    
    private let posterUploadForm = PosterUploadForm()
    
    private let artistNameForm = {
        let form = CounterTextForm(maxByte: 20)
        form.textField.setPlaceHolder("아티스트명을 입력해주세요 (20자 이내)")
        form.titleLabel.config.text = "아티스트명"
        return form
    }()
    
    private let artistDescriptionForm = {
        let form = CounterMultilineTextForm(maxByte: 200)
        form.textView.setPlaceHolder("아티스트 소개글을 입력해주세요 (200자 이내)")
        form.titleLabel.config.text = "아티스트 소개"
        return form
    }()
    
    private let noticeForm = {
        let form = TextForm()
        form.textField.setPlaceHolder("ex. 슬리퍼, 운동복, 등산복 입장 불가")
        form.titleLabel.config.text = "공연 유의사항"
        return form
    }()
    
    private let documentUploadForm = DocumentUploadForm()
    
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
        contentVStack.addArrangedSubview(genreForm)
        contentVStack.addArrangedSubview(LOSpacer(24))
        contentVStack.addArrangedSubview(descriptionForm)
        contentVStack.addArrangedSubview(LOSpacer(24))
        contentVStack.addArrangedSubview(posterUploadForm)
        contentVStack.addArrangedSubview(LOSpacer(24))
        contentVStack.addArrangedSubview(atristInfoTitleLabel)
        contentVStack.addArrangedSubview(LOSpacer(16))
        contentVStack.addArrangedSubview(artistNameForm)
        contentVStack.addArrangedSubview(LOSpacer(24))
        contentVStack.addArrangedSubview(artistDescriptionForm)
        contentVStack.addArrangedSubview(LOSpacer(20))
        contentVStack.addArrangedSubview(noticeTitleLabel)
        contentVStack.addArrangedSubview(LOSpacer(16))
        contentVStack.addArrangedSubview(noticeForm)
        contentVStack.addArrangedSubview(LOSpacer(24))
        contentVStack.addArrangedSubview(documentUploadForm)
        contentVStack.addArrangedSubview(LOSpacer(20))
        contentVStack.addArrangedSubview(confirmButton)
        
        scrollView.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
        contentVStack.snp.makeConstraints { $0.edges.width.equalToSuperview() }
        
        // 오버레이 뷰 레이아웃
        addressForm.provinceDropdown.setupOverlayLayout(superView: contentVStack)
        addressForm.cityDropdown.setupOverlayLayout(superView: contentVStack)
        genreForm.dropdown.setupOverlayLayout(superView: contentVStack)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let input = RegisterBuskingVM.Input(
            name: nameForm.validTextPublisher,
            description: descriptionForm.validTextPublisher,
            regionID: addressForm.regionIDPublisher,
            detailAddress: addressForm.detailAddressPublisher,
            notice: noticeForm.textPublisher,
            genre: genreForm.genrePublisher,
            posterPath: Empty<String?, Never>().eraseToAnyPublisher(),
            startDate: scheduleForm.startDatePublisher,
            endDate: scheduleForm.endDatePublisher,
            startTime: scheduleForm.startTimePublisher,
            endTime: scheduleForm.endTimePublisher,
            documentPath: Empty<String?, Never>().eraseToAnyPublisher(),
            artistName: artistNameForm.validTextPublisher,
            artistDescription: artistDescriptionForm.validTextPublisher
        )
        
        let output = vm.transform(input)
        
        output.info
            .sink {
                print("""
                -------------------
                name             = \($0.name ?? "nil")
                description      = \($0.description ?? "nil")
                regionID         = \($0.regionID?.description ?? "nil")
                detailAddress    = \($0.detailAddress ?? "nil")
                notice           = \($0.notice ?? "nil")
                genre            = \($0.genre)
                posterPath       = \($0.posterPath ?? "nil")
                startDate        = \($0.startDate ?? "nil")
                endDate          = \($0.endDate ?? "nil")
                startTime        = \($0.startTime ?? "nil")
                endTime          = \($0.endTime ?? "nil")
                documentPath     = \($0.documentPath ?? "nil")
                artistName       = \($0.artistName ?? "nil")
                artistDescription= \($0.artistDescription ?? "nil")
                """)
            }
            .store(in: &cancellables)
        
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

extension RegisterBuskingVC {
    /// 배경을 터치하면, 오버레이 닫기 (키보드 포함)
    private func bindDismissOverlay(gesture: UITapGestureRecognizer) {
        addressForm.provinceDropdown.bindDismissTable(gesture)
        addressForm.cityDropdown.bindDismissTable(gesture)
        genreForm.dropdown.dismiss(gesture)
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

#Preview { RegisterBuskingVC() }

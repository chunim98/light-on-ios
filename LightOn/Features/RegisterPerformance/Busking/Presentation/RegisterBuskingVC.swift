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
    private let vm = RegisterPerformanceDI.shared.makeRegisterBuskingVM()
    
    // MARK: Subjects
    
    /// 공연 등록 완료 서브젝트
    private let registerCompleteSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Alerts
    
    private let confirmAlert = RegisterBuskingConfirmAlertVC()
    
    // MARK: Containers
    
    private let scrollView = ResponsiveScrollView()
    private let contentVStack = TapStackView(.vertical, inset: .init(horizontal: 18))
    
    // MARK: Buttons
    
    private let confirmButton = {
        let button = LOButton(style: .filled)
        button.setTitle("등록하기", .pretendard.bold(16))
        return button
    }()
    
    // MARK: Labels
    
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
    
    // MARK: Forms
    
    private let nameForm = {
        let form = CounterMultilineTextForm(maxByte: 50)
        form.textView.setPlaceHolder("공연명을 입력해주세요 (50자 이내)")
        form.titleLabel.config.text = "공연명"
        return form
    }()
    
    private lazy var scheduleForm = ScheduleForm(presenter: self)
    
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
    
    private lazy var posterUploadForm = {
        let form = ImageUploadForm(presenter: self)
        form.titleLabel.config.text = "공연 홍보 이미지"
        form.textField.setPlaceHolder("공연 포스터 및 사진 업로드")
        return form
    }()
    
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
    
    private lazy var documentUploadForm = {
        let form = ImageUploadForm(presenter: self)
        form.titleLabel.config.text = "공연 진행 증빙자료"
        form.textField.setPlaceHolder("파일을 업로드 해주세요")
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
        
        scrollView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(contentLayoutGuide)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        contentVStack.snp.makeConstraints { $0.edges.width.equalToSuperview() }
        
        // 오버레이 뷰 레이아웃
        addressForm.provinceDropdown.setupOverlayLayout(superView: contentVStack)
        addressForm.cityDropdown.setupOverlayLayout(superView: contentVStack)
        genreForm.dropdown.setupOverlayLayout(superView: contentVStack)
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
        
        // 배경 터치 시, 모든 오버레이 닫기 (키보드 포함)
        contentVStack.tapPublisher
            .sink { [weak self] in self?.dismissOverlays(gesture: $0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension RegisterBuskingVC {
    /// 배경 터치 시, 모든 오버레이 닫기 (키보드 포함)
    private func dismissOverlays(gesture: UITapGestureRecognizer) {
        addressForm.provinceDropdown.bindDismissTable(gesture)
        addressForm.cityDropdown.bindDismissTable(gesture)
        genreForm.dropdown.dismiss(gesture)
        view.endEditing(true) // 키보드 닫기
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

#Preview { RegisterBuskingVC() }

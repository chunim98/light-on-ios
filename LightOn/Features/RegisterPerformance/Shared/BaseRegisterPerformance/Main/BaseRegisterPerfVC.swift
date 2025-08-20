//
//  BaseRegisterPerfVC.swift
//  LightOn
//
//  Created by 신정욱 on 8/20/25.
//

import UIKit
import Combine

import SnapKit

class BaseRegisterPerfVC: BackButtonVC {
    
    // MARK: Properties
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: Containers
    
    private let scrollView = ResponsiveScrollView()
    let contentVStack = TapStackView(.vertical, inset: .init(horizontal: 18))
    
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
    
    /// 공연명
    let nameForm = {
        let form = CounterMultilineTextForm(maxByte: 50)
        form.textView.setPlaceHolder("공연명을 입력해주세요 (50자 이내)")
        form.titleLabel.config.text = "공연명"
        return form
    }()
    
    /// 공연 일시
    ///
    /// 모달을 내부에서 띄워야 해서 현재 뷰컨 인스턴스를 전달
    private(set) lazy var scheduleForm = ScheduleForm(presenter: self)
    
    /// 공연 장소
    ///
    /// 오버레이 컴포넌트 배치를 위해 여기서 레이아웃 지정
    let addressForm = {
        let form = AddressForm()
        form.titleLabel.config.text = "공연 장소"
        form.textField.setPlaceHolder("상세주소")
        return form
    }()
    
    /// 공연 장르
    ///
    /// 오버레이 컴포넌트 배치를 위해 여기서 레이아웃 지정
    let genreForm = GenreForm()
    
    /// 공연 소개
    let descriptionForm = {
        let form = CounterMultilineTextForm(maxByte: 500)
        form.textView.setPlaceHolder("공연 소개 내용을 작성해 주세요 (500자 이내)")
        form.titleLabel.config.text = "공연 소개"
        return form
    }()
    
    /// 공연 홍보 이미지
    ///
    /// 모달을 내부에서 띄워야 해서 현재 뷰컨 인스턴스를 전달
    private(set) lazy var posterUploadForm = {
        let form = ImageUploadForm(presenter: self)
        form.titleLabel.config.text = "공연 홍보 이미지"
        form.textField.setPlaceHolder("공연 포스터 및 사진 업로드")
        return form
    }()
    
    /// 아티스트명
    let artistNameForm = {
        let form = CounterTextForm(maxByte: 20)
        form.textField.setPlaceHolder("아티스트명을 입력해주세요 (20자 이내)")
        form.titleLabel.config.text = "아티스트명"
        return form
    }()
    
    /// 아티스트 소개
    let artistDescriptionForm = {
        let form = CounterMultilineTextForm(maxByte: 200)
        form.textView.setPlaceHolder("아티스트 소개글을 입력해주세요 (200자 이내)")
        form.titleLabel.config.text = "아티스트 소개"
        return form
    }()
    
    /// 공연 유의사항
    let noticeForm = {
        let form = TextForm()
        form.textField.setPlaceHolder("ex. 슬리퍼, 운동복, 등산복 입장 불가")
        form.titleLabel.config.text = "공연 유의사항"
        return form
    }()
    
    /// 공연 진행 증빙자료
    ///
    /// 모달을 내부에서 띄워야 해서 현재 뷰컨 인스턴스를 전달
    private(set) lazy var documentUploadForm = {
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
        
        scrollView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(contentLayoutGuide)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        contentVStack.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
        // 오버레이 뷰 레이아웃
        addressForm.provinceDropdown.setupOverlayLayout(superView: contentVStack)
        addressForm.cityDropdown.setupOverlayLayout(superView: contentVStack)
        genreForm.dropdown.setupOverlayLayout(superView: contentVStack)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 배경 터치 시, 모든 오버레이 닫기 (키보드 포함)
        contentVStack.tapPublisher
            .sink { [weak self] in self?.dismissOverlays(gesture: $0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension BaseRegisterPerfVC {
    /// 배경 터치 시, 모든 오버레이 닫기 (키보드 포함)
    private func dismissOverlays(gesture: UITapGestureRecognizer) {
        addressForm.provinceDropdown.bindDismissTable(gesture)
        addressForm.cityDropdown.bindDismissTable(gesture)
        genreForm.dropdown.dismiss(gesture)
        view.endEditing(true) // 키보드 닫기
    }
}

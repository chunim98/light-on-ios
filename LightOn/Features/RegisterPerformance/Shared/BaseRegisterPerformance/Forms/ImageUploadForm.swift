//
//  ImageUploadForm.swift
//  LightOn
//
//  Created by 신정욱 on 7/14/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class ImageUploadForm: TextForm {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    /// 피커를 띄워줄 프레젠터
    private weak var presenter: UIViewController?
    
    // MARK: Components
    
    /// 피커 풀 스크린 모달
    private let pickerVC = PHPickerVC()
    
    private let importButton = {
        let button = LOButton(style: .borderedTinted)
        button.setTitle("파일 업로드", .pretendard.semiBold(16))
        button.snp.makeConstraints { $0.width.equalTo(109) }
        return button
    }()
    
    private let captionLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .infoText
        config.text = "* 10mb 이하 PDF, png, jpeg, jpg, 파일만 업로드 가능합니다."
        return LOLabel(config: config)
    }()
    
    // MARK: Life Cycle
    
    init(presenter: UIViewController?) {
        self.presenter = presenter
        super.init(frame: .zero)
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    @MainActor required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() { textField.isEnabled = false }
    
    // MARK: Layout
    
    private func setupLayout() {
        addArrangedSubview(captionLabel)
        textFieldHStack.addArrangedSubview(LOSpacer(12))
        textFieldHStack.addArrangedSubview(importButton)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 업로드 버튼 탭 시, 이미지 피커 표시
        importButton.tapPublisher
            .sink { [weak self] in self?.presentPHPicker() }
            .store(in: &cancellables)
        
        // 이미지 선택 완료 또는 취소 시, 피커 닫기
        Publishers.Merge(
            pickerVC.selectedImageInfoPublisher.map { _ in },
            pickerVC.cancelTapPublisher
        )
        .sink { [weak self] in
            self?.pickerVC.dismiss(animated: false)
        }
        .store(in: &cancellables)
        
        // 전달받은 이미지 정보로 텍스트필드 UI 업데이트
        pickerVC.selectedImageInfoPublisher
            .sink { [weak self] in self?.updateUI(with: $0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension ImageUploadForm {
    /// PHPicker 열기
    private func presentPHPicker() {
        pickerVC.modalPresentationStyle = .overFullScreen
        presenter?.present(pickerVC, animated: false)
    }
    
    /// 전달받은 이미지 정보로 텍스트필드 UI 업데이트
    private func updateUI(with info: ImageInfo) {
        textField.layer.borderColor = UIColor.loBlack.cgColor
        textField.text = info.name
    }
    
    /// 선택한 이미지 정보 퍼블리셔
    var imageInfoPublisher: AnyPublisher<ImageInfo, Never> {
        pickerVC.selectedImageInfoPublisher
    }
}

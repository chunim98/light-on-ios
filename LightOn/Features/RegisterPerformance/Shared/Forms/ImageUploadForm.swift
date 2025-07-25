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
    private weak var presenter: UIViewController?
    
    // MARK: Components
    
    private let pickerVC = PHPickerVC()
    
    let button = {
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
        textFieldHStack.addArrangedSubview(button)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 업로드 버튼 탭, 이미지 피커 열기
        button.tapPublisher
            .sink { [weak self] in self?.bindShowPHPicker() }
            .store(in: &cancellables)
        
        // 닫기 버튼 탭, 이미지 선택, 이미지 피커 닫기
        Publishers.Merge(
            pickerVC.cancelTapPublisher,
            pickerVC.selectedImageInfoPublisher.print().map { _ in }
        )
        .sink { [weak self] in self?.pickerVC.dismiss(animated: true) }
        .store(in: &cancellables)
        
        pickerVC.selectedImageInfoPublisher
            .sink { [weak self] in
                self?.textField.layer.borderColor = UIColor.loBlack.cgColor
                self?.textField.text = $0.name
            }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension ImageUploadForm {
    /// PHPicker 열기 바인딩
    private func bindShowPHPicker() {
        pickerVC.modalPresentationStyle = .overFullScreen
        presenter?.present(pickerVC, animated: false)
    }
    
    /// 선택한 이미지 정보 퍼블리셔
    var imageInfoPublisher: AnyPublisher<ImageInfo, Never> {
        pickerVC.selectedImageInfoPublisher
    }
}

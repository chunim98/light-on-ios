//
//  ImageUploadFormVC.swift
//  LightOn
//
//  Created by 신정욱 on 8/21/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class ImageUploadFormVC: UIViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    /// 피커 풀 스크린 모달
    private let pickerVC = PHPickerVC()
    
    let baseForm = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(12)
        config.foregroundColor = .infoText
        config.text = "* 10mb 이하 PDF, png, jpeg, jpg, 파일만 업로드 가능합니다."
        let label = LOLabel(config: config)
        
        let form = TextForm()
        form.textField.isEnabled = false
        form.addArrangedSubview(label)
        return form
    }()
    
    private let importButton = {
        let button = LOButton(style: .borderedTinted)
        button.setTitle("파일 업로드", .pretendard.semiBold(16))
        button.snp.makeConstraints { $0.width.equalTo(109) }
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
        view.addSubview(baseForm)
        baseForm.textFieldHStack.addArrangedSubview(LOSpacer(12))
        baseForm.textFieldHStack.addArrangedSubview(importButton)
        
        baseForm.snp.makeConstraints { $0.edges.equalToSuperview() }
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

extension ImageUploadFormVC {
    /// PHPicker 풀스크린 모달 띄우기
    private func presentPHPicker() {
        pickerVC.modalPresentationStyle = .overFullScreen
        present(pickerVC, animated: false)
    }
    
    /// 전달받은 이미지 정보로 텍스트필드 UI 업데이트
    private func updateUI(with info: ImageInfo) {
        baseForm.textField.layer.borderColor = UIColor.loBlack.cgColor
        baseForm.textField.text = info.name
    }
    
    /// 선택한 이미지 정보 퍼블리셔
    var imageInfoPublisher: AnyPublisher<ImageInfo, Never> {
        pickerVC.selectedImageInfoPublisher
    }
}

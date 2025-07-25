//
//  PHPickerVC.swift
//  TennisPark
//
//  Created by 신정욱 on 7/2/25.
//

import UIKit
import Combine
import PhotosUI

import CombineCocoa
import SnapKit

final class PHPickerVC: UIViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = PHPickerVM()
    
    // MARK: Inputs
    
    private let pickingResultsSubject = PassthroughSubject<[PHPickerResult], Never>()
    
    // MARK: Outputs
    
    private let cancelTapSubject = PassthroughSubject<Void, Never>()
    private let selectedImageInfoSubject = PassthroughSubject<ImageInfo, Never>()
    
    // MARK: Components
    
    private let pickerVC = {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1 // 0은 무제한
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.isModalInPresentation = true
        return vc
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        present(pickerVC, animated: true)   // 이미지 피커 열기
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        view.backgroundColor = .clear
        pickerVC.delegate = self
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let input = PHPickerVM.Input(
            pickingResults: pickingResultsSubject.eraseToAnyPublisher()
        )
        
        let output = vm.transform(input)
        
        output.cancelTap
            .sink { [weak self] in self?.cancelTapSubject.send(()) }
            .store(in: &cancellables)
        
        output.selectedImageInfo
            .sink { [weak self] in self?.selectedImageInfoSubject.send($0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension PHPickerVC {
    /// 취소버튼 탭 퍼블리셔
    var cancelTapPublisher: AnyPublisher<Void, Never> {
        cancelTapSubject.eraseToAnyPublisher()
    }
    
    /// 선택한 이미지 정보 퍼블리셔
    var selectedImageInfoPublisher: AnyPublisher<ImageInfo, Never> {
        selectedImageInfoSubject.eraseToAnyPublisher()
    }
}

// MARK: - PHPickerViewControllerDelegate

extension PHPickerVC: PHPickerViewControllerDelegate {
    /// "취소" 또는 "완료"를 눌러서 picker를 종료할 때 호출됨
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        // 이미지 피커 닫기
        picker.dismiss(animated: true) { [weak self] in
            self?.pickingResultsSubject.send(results)
        }
    }
}

// MARK: - Preview

#Preview { PHPickerVC() }

//
//  ViewController.swift
//  LightOn
//
//  Created by 신정욱 on 4/28/25.
//

import UIKit
import Combine

import SnapKit

final class ViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    private let kakaoAuthHelper = KakaoAuthHelper()
    
    // MARK: Components
    
//    private lazy var alert = LOAlertVC(
//        base: self,
//        content: LOSwitch(),
//        headerTitle: "알림",
//        acceptTitle: "확인",
//        cancelTitle: "취소"
//    )
    
    private let mainVStack = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 15
        return sv
    }()
    
    private let kakaoSignInButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle("카카오 로그인", for: .normal)
        return button
    }()
    
    private let alertButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle("얼럿 열기", for: .normal)
        return button
    }()
    
//    private let datePicker = LODatePicker()
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupBindings()
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(kakaoSignInButton)
        mainVStack.addArrangedSubview(alertButton)
//        mainVStack.addArrangedSubview(datePicker)
        
        mainVStack.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(15)
        }
        kakaoSignInButton.snp.makeConstraints { $0.height.equalTo(50) }
        alertButton.snp.makeConstraints { $0.height.equalTo(50) }
//        datePicker.snp.makeConstraints { $0.height.equalTo(400) }
    }

    // MARK: Bindings
    
    private func setupBindings() {
        kakaoSignInButton.tapPublisher
            .sink { [weak self] _ in self?.kakaoAuthHelper.signInBinder() }
            .store(in: &cancellables)
        
        kakaoAuthHelper.resultTextPublisher
            .sink { [weak self] in self?.pushResultVCBinder($0) }
            .store(in: &cancellables)
        
        alertButton.tapPublisher
            .sink { [weak self] _ in /*self?.alert.show()*/ }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension ViewController {
    private func pushResultVCBinder(_ resultText: String) {
        let vc = ResultVC(resultText: resultText)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Preview

#Preview { ViewController() }

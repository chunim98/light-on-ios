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
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setAutoLayout()
        setBinding()
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(kakaoSignInButton)

        mainVStack.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(15)
        }
        kakaoSignInButton.snp.makeConstraints { $0.height.equalTo(50) }
    }

    // MARK: Binding
    
    private func setBinding() {
        kakaoSignInButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in self?.kakaoAuthHelper.signInBinder() }
            .store(in: &cancellables)
        
        kakaoAuthHelper.resultTextPublisher
            .sink { [weak self] in self?.pushResultVCBinder($0) }
            .store(in: &cancellables)
    }
}

// MARK: - Event Handling

extension ViewController {
    private func pushResultVCBinder(_ resultText: String) {
        let vc = ResultVC(resultText: resultText)
        navigationController?.pushViewController(vc, animated: true)
    }
}

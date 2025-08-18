//
//  MyPageProfileHeaderVC.swift
//  LightOn
//
//  Created by 신정욱 on 8/18/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class MyPageProfileHeaderVC: CombineVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private var myActivityHistoryCoord: MyActivityHistoryCoordinator?
    
    // MARK: Components
    
    private let mainVStack = UIStackView(
        .vertical, inset: .init(horizontal: 18, vertical: 30)
    )
    
    /// 공연 등록 분기 모달
    private let entryModalVC = RegisterPerformanceEntryModalVC()
    /// 로그아웃 상태의 헤더 뷰
    private let logoutView = MyPageLogoutHeaderView()
    /// 로그인 상태의 헤더 뷰
    private let loginVC = MyPageLoginHeaderVC()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() { view.backgroundColor = .xF5F0FF }
    
    // MARK: Layout
    
    private func setupLayout() {
        addChild(loginVC)
        
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(loginVC.view)
        mainVStack.addArrangedSubview(logoutView)
        mainVStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        loginVC.didMove(toParent: self)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // viewDidAppear 시, 로그인 상태에 따라 뷰 표시 전환
        viewDidAppearPublisher
            .sink { [weak self] in self?.updateVisibility() }
            .store(in: &cancellables)
        
        // 로그아웃 상태: 로그인 화면 이동
        logoutView.loginButton.tapPublisher
            .sink { AppCoordinatorBus.shared.navigate(to: .login) }
            .store(in: &cancellables)
        
        // 로그아웃 상태: 회원가입 화면 이동
        logoutView.signUpButton.tapPublisher
            .sink { AppCoordinatorBus.shared.navigate(to: .signUp) }
            .store(in: &cancellables)
        
        // 로그인 상태: 내 활동 내역 코디네이터 시작
        loginVC.activityHistotyButton.tapPublisher
            .sink { [weak self] in self?.startMyActivityHistory() }
            .store(in: &cancellables)
        
        // 로그인 상태: 공연 등록 모달 열기
        loginVC.performanceRegisterButton.tapPublisher
            .sink { [weak self] in self?.presentEntryModal() }
            .store(in: &cancellables)
        
        // 로그인 상태: 일반 공연 등록 화면 이동
        entryModalVC.normalTapPublisher
            .sink { AppCoordinatorBus.shared.navigate(to: .registerConcert) }
            .store(in: &cancellables)
        
        // 로그인 상태: 버스킹 등록 화면 이동
        entryModalVC.buskingTapPublisher
            .sink { AppCoordinatorBus.shared.navigate(to: .registerBusking) }
            .store(in: &cancellables)
    }
}

extension MyPageProfileHeaderVC {
    /// 공연 등록 모달 열기
    private func presentEntryModal() { present(entryModalVC, animated: true) }
    
    /// 로그인 상태에 따라 뷰 표시 전환
    private func updateVisibility() {
        let isLogin = SessionManager.shared.loginState == .login
        loginVC.view.isHidden = !isLogin
        logoutView.isHidden = isLogin
    }
    
    /// 내 활동 내역 코디네이터 시작
    private func startMyActivityHistory() {
        myActivityHistoryCoord = .init(navigation: navigationController!)
        myActivityHistoryCoord?.start()
    }
}


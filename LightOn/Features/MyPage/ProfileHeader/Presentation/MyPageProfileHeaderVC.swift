//
//  MyPageProfileHeaderVC.swift
//  LightOn
//
//  Created by 신정욱 on 8/18/25.
//

import UIKit
import Combine
import SafariServices

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
    /// "아티스트 회원 아님" 안내 얼럿
    private let notArtistAlertVC = NotArtistAlertVC()
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
        
        // 로그인 상태: 아티스트 확인 후, 일반 공연 등록 화면 이동
        entryModalVC.normalTapPublisher
            .sink { [weak self] in
                SessionManager.shared.isArtist
                ? AppCoordinatorBus.shared.navigate(to: .registerConcert)
                : self?.presentNotArtistAlert()
            }
            .store(in: &cancellables)
        
        // 로그인 상태: 버스킹 등록 화면 이동
        entryModalVC.buskingTapPublisher
            .sink { AppCoordinatorBus.shared.navigate(to: .registerBusking) }
            .store(in: &cancellables)
        
        // 아티스트 신청 페이지로 리디렉션
        notArtistAlertVC.acceptTapPublisher
            .sink { [weak self] in self?.openSafari(
                with: "https://docs.google.com/forms/d/e/1FAIpQLSc3WM6-wQSMTYBBYXxCN5loa8LcoRYR08Ju82IDSgchrhHE8g/viewform"
            ) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension MyPageProfileHeaderVC {
    /// 공연 등록 모달 열기
    private func presentEntryModal() { present(entryModalVC, animated: true) }
    
    /// "아티스트 회원 아님" 얼럿 띄우기
    private func presentNotArtistAlert() {
        notArtistAlertVC.modalPresentationStyle = .overFullScreen
        notArtistAlertVC.modalTransitionStyle = .crossDissolve
        present(notArtistAlertVC, animated: true)
    }
    
    /// 주어진 URL을 Safari 뷰 컨트롤러로 열기
    private func openSafari(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    /// 내 활동 내역 코디네이터 시작
    private func startMyActivityHistory() {
        myActivityHistoryCoord = .init(navigation: navigationController!)
        myActivityHistoryCoord?.start()
    }
    
    /// 로그인 상태에 따라 뷰 표시 전환
    func updateVisibility() {
        let isLogin = SessionManager.shared.loginState == .login
        loginVC.view.isHidden = !isLogin
        logoutView.isHidden = isLogin
    }
}


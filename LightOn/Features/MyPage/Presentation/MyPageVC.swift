//
//  MyPageVC.swift
//  LightOn
//
//  Created by 신정욱 on 6/26/25.
//

import UIKit
import Combine
import SafariServices

import CombineCocoa
import SnapKit

final class MyPageVC: NavigationBarVC {
    
    // MARK: Properties
    
    private let vm = MyPageVM()
    private var cancellables = Set<AnyCancellable>()
    
    private var registerPerformanceFlowCoord: RegisterPerformanceFlowCoordinator?
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical)
    private let scrollView = UIScrollView()
    private let contentVStack = UIStackView(
        .vertical, inset: .init(horizontal: 18, vertical: 15)
    )
    
    private let loginInfoView = MyPageLoginInfoView()
    private let logoutInfoView = MyPageLogoutInfoView()
    
    private let noticeButton        = MyPageRowButton(title: "공지사항")
    private let appSettingsButton   = MyPageRowButton(title: "앱 설정")
    private let faqButton           = MyPageRowButton(title: "FAQ")
    private let joinArtistButton    = MyPageRowButton(title: "아티스트 신청")
    private let termsButton         = MyPageRowButton(title: "이용약관")
    private let versionButton       = MyPageRowButton(title: "버전 정보")
    private let logoutButton        = MyPageRowButton(title: "로그아웃")
    private let deleteAccountButton = MyPageRowButton(title: "회원 탈퇴")
    
    private let dividers = { (0..<3).map { _ in
        let sv = UIStackView(.vertical)
        sv.addArrangedSubview(LOSpacer(8))
        sv.addArrangedSubview(LODivider(height: 1, color: .background))
        sv.addArrangedSubview(LOSpacer(8))
        return sv
    } }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBar?.setTabBarHidden(false)
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        navigationBar.titleLabel.config.text = "마이페이지"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(loginInfoView)
        mainVStack.addArrangedSubview(logoutInfoView)
        mainVStack.addArrangedSubview(scrollView)
        
        scrollView.addSubview(contentVStack)
        contentVStack.addArrangedSubview(noticeButton)
        contentVStack.addArrangedSubview(appSettingsButton)
        contentVStack.addArrangedSubview(faqButton)
        contentVStack.addArrangedSubview(dividers[0])
        contentVStack.addArrangedSubview(joinArtistButton)
        contentVStack.addArrangedSubview(dividers[1])
        contentVStack.addArrangedSubview(termsButton)
        contentVStack.addArrangedSubview(versionButton)
        contentVStack.addArrangedSubview(dividers[2])
        contentVStack.addArrangedSubview(logoutButton)
        contentVStack.addArrangedSubview(deleteAccountButton)
        
        mainVStack.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
        contentVStack.snp.makeConstraints { $0.edges.width.equalToSuperview() }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let input = MyPageVM.Input(
            loginTap: logoutInfoView.loginButton.tapPublisher,
            signUpTap: logoutInfoView.signUpButton.tapPublisher
        )
        
        let output = vm.transform(input)
        
        output.state
            .sink { [weak self] in self?.bindState(state: $0) }
            .store(in: &cancellables)
        
        // 공연 등록 플로우 시작
        loginInfoView.performanceRegisterButton.tapPublisher
            .sink { [weak self] in self?.bindStartRegisterPerformanceFlow() }
            .store(in: &cancellables)
        
        // 이용약관 페이지로 리디렉션
        termsButton.tapPublisher
            .sink { [weak self] in
                let url = URL(string: "https://climbing-crop-26b.notion.site/229eaa9122bb80d587c6d186c37a2c79")!
                let safariVC = SFSafariViewController(url: url)
                self?.present(safariVC, animated: true)
            }
            .store(in: &cancellables)
        
        // FAQ 페이지로 리디렉션
        faqButton.tapPublisher
            .sink { [weak self] in
                let url = URL(string: "https://climbing-crop-26b.notion.site/FAQ-239eaa9122bb80bfb9b9edb50dd1936e")!
                let safariVC = SFSafariViewController(url: url)
                self?.present(safariVC, animated: true)
            }
            .store(in: &cancellables)
        
        // 아티스트 신청 페이지로 리디렉션
        joinArtistButton.tapPublisher
            .sink { [weak self] in
                let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSc3WM6-wQSMTYBBYXxCN5loa8LcoRYR08Ju82IDSgchrhHE8g/viewform")!
                let safariVC = SFSafariViewController(url: url)
                self?.present(safariVC, animated: true)
            }
            .store(in: &cancellables)
        
        loginInfoView.activityHistotyButton.tapPublisher
            .sink { [weak self] in
                let vc = MyActivityHistoryVC()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension MyPageVC {
    /// 뷰 상태 바인딩
    private func bindState(state: MyPageState) {
        logoutInfoView.isHidden = state.loggedOutInfoViewHidden
        loginInfoView.isHidden = state.loggedInInfoViewHidden
        
        deleteAccountButton.isHidden = state.deleteAccountButtonHidden
        joinArtistButton.isHidden = state.joinArtistButtonHidden
        logoutButton.isHidden = state.logoutButtonHidden
        
        zip(dividers, state.dividersHidden).forEach { $0.0.isHidden = $0.1 }
    }
    
    /// 공연 등록 플로우 시작
    private func bindStartRegisterPerformanceFlow() {
        registerPerformanceFlowCoord = .init(
            navigation: navigationController!,
            tabBar: tabBar
        )
        registerPerformanceFlowCoord?.start()
    }
}

// MARK: - Preview

#Preview { MyPageVC() }

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
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    /// 로그아웃 얼럿
    private let logoutAlertVC = LogoutAlertVC()
    /// 회원탈퇴 얼럿
    private let deleteAccountAlertVC = DeleteAccountAlertVC()
    
    private let mainVStack = UIStackView(.vertical)
    private let scrollView = UIScrollView()
    private let contentVStack = UIStackView(.vertical, inset: .init(horizontal: 18, vertical: 15))
    
    /// 프로필 헤더 컨테이너 뷰컨
    private let profileHeaderVC = MyPageProfileHeaderVC()
    
    // 메뉴 버튼들
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
    
    // MARK: Defaults
    
    private func setupDefaults() {
        navigationBar.titleLabel.config.text = "마이페이지"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addChild(profileHeaderVC)
        
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(profileHeaderVC.view)
        mainVStack.addArrangedSubview(scrollView)
        
        #warning("미구현 기능의 버튼 제외")
        scrollView.addSubview(contentVStack)
        // contentVStack.addArrangedSubview(noticeButton)
        // contentVStack.addArrangedSubview(appSettingsButton)
        contentVStack.addArrangedSubview(faqButton)
        contentVStack.addArrangedSubview(dividers[0])
        contentVStack.addArrangedSubview(joinArtistButton)
        contentVStack.addArrangedSubview(dividers[1])
        contentVStack.addArrangedSubview(termsButton)
        // contentVStack.addArrangedSubview(versionButton)
        contentVStack.addArrangedSubview(dividers[2])
        contentVStack.addArrangedSubview(logoutButton)
        contentVStack.addArrangedSubview(deleteAccountButton)
        
        mainVStack.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
        contentVStack.snp.makeConstraints { $0.edges.width.equalToSuperview() }
        
        profileHeaderVC.didMove(toParent: self)
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        // 화면 진입 또는 로그아웃, 회원탈퇴 완료 시, 뷰 표시 상태 갱신
        Publishers.Merge3(
            logoutAlertVC.logoutCompletedPublisher,
            deleteAccountAlertVC.accountDeletedPublisher,
            viewDidAppearPublisher
        )
        .sink { [weak self] in
            self?.profileHeaderVC.updateVisibility()
            self?.updateVisibility()
        }
        .store(in: &cancellables)
        
        // 로그아웃 얼럿 띄우기
        logoutButton.tapPublisher
            .sink { [weak self] in self?.presentLogoutAlert() }
            .store(in: &cancellables)
        
        // 회원탈퇴 얼럿 띄우기
        deleteAccountButton.tapPublisher
            .sink { [weak self] in self?.presentdeleteAccountAlert() }
            .store(in: &cancellables)
        
        // 이용약관 페이지로 리디렉션
        termsButton.tapPublisher
            .sink { [weak self] in self?.openSafari(
                with: "https://climbing-crop-26b.notion.site/229eaa9122bb80d587c6d186c37a2c79"
            ) }
            .store(in: &cancellables)
        
        // FAQ 페이지로 리디렉션
        faqButton.tapPublisher
            .sink { [weak self] in self?.openSafari(
                with: "https://climbing-crop-26b.notion.site/FAQ-239eaa9122bb80bfb9b9edb50dd1936e"
            ) }
            .store(in: &cancellables)
        
        // 아티스트 신청 페이지로 리디렉션
        joinArtistButton.tapPublisher
            .sink { [weak self] in self?.openSafari(
                with: "https://docs.google.com/forms/d/e/1FAIpQLSc3WM6-wQSMTYBBYXxCN5loa8LcoRYR08Ju82IDSgchrhHE8g/viewform"
            ) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension MyPageVC {
    /// 로그인 상태에 따라 뷰 표시 전환
    private func updateVisibility() {
        let isLogin = SessionManager.shared.loginState == .login
        let state = isLogin ? MyPageState.login : MyPageState.logout
        
        deleteAccountButton.isHidden = state.deleteAccountButtonHidden
        joinArtistButton.isHidden = state.joinArtistButtonHidden
        logoutButton.isHidden = state.logoutButtonHidden
        
        zip(dividers, state.dividersHidden).forEach { $0.0.isHidden = $0.1 }
    }
    
    /// 주어진 URL을 Safari 뷰 컨트롤러로 열기
    private func openSafari(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    /// 로그아웃 얼럿 띄우기
    private func presentLogoutAlert() {
        logoutAlertVC.modalPresentationStyle = .overFullScreen
        logoutAlertVC.modalTransitionStyle = .crossDissolve
        present(logoutAlertVC, animated: true)
    }
    
    /// 회원탈퇴 얼럿 띄우기
    private func presentdeleteAccountAlert() {
        deleteAccountAlertVC.modalPresentationStyle = .overFullScreen
        deleteAccountAlertVC.modalTransitionStyle = .crossDissolve
        present(deleteAccountAlertVC, animated: true)
    }
}

// MARK: - Preview

#Preview { MyPageVC() }

//
//  MyPageVC.swift
//  LightOn
//
//  Created by 신정욱 on 6/26/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class MyPageVC: NavigationBarVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical)
    private let scrollView = UIScrollView()
    private let contentVStack = UIStackView(
        .vertical, inset: .init(horizontal: 18, vertical: 15)
    )
    
    private let userInfoSection = MyPageUserInfoSectionView()
    
    private let noticeButton        = MyPageRowButton(title: "공지사항")
    private let appSettingsButton   = MyPageRowButton(title: "앱 설정")
    private let faqButton           = MyPageRowButton(title: "FAQ")
    private let joinArtistButton    = MyPageRowButton(title: "아티스트 신청")
    private let termsButton         = MyPageRowButton(title: "이용약관")
    private let versionButton       = MyPageRowButton(title: "버전 정보")
    private let logoutButton        = MyPageRowButton(title: "로그아웃")
    private let deleteAccountButton = MyPageRowButton(title: "회원 탈퇴")
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        navigationBar.titleLabel.config.text = "마이페이지"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(userInfoSection)
        mainVStack.addArrangedSubview(scrollView)
        
        scrollView.addSubview(contentVStack)
        contentVStack.addArrangedSubview(noticeButton)
        contentVStack.addArrangedSubview(appSettingsButton)
        contentVStack.addArrangedSubview(faqButton)
        contentVStack.addArrangedSubview(LOSpacer(8))
        contentVStack.addArrangedSubview(LODivider(height: 1, color: .background))
        contentVStack.addArrangedSubview(LOSpacer(8))
        contentVStack.addArrangedSubview(joinArtistButton)
        contentVStack.addArrangedSubview(LOSpacer(8))
        contentVStack.addArrangedSubview(LODivider(height: 1, color: .background))
        contentVStack.addArrangedSubview(LOSpacer(8))
        contentVStack.addArrangedSubview(termsButton)
        contentVStack.addArrangedSubview(versionButton)
        contentVStack.addArrangedSubview(LOSpacer(8))
        contentVStack.addArrangedSubview(LODivider(height: 1, color: .background))
        contentVStack.addArrangedSubview(LOSpacer(8))
        contentVStack.addArrangedSubview(logoutButton)
        contentVStack.addArrangedSubview(deleteAccountButton)
        
        mainVStack.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
        contentVStack.snp.makeConstraints { $0.edges.width.equalToSuperview() }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {}
}

// MARK: - Preview

#Preview { MyPageVC() }

//
//  PerformanceDetailVC.swift
//  LightOn
//
//  Created by 신정욱 on 6/25/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class PerformanceDetailVC: BackButtonViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical)
    private let scrollView = UIScrollView()
    private let contentVStack = UIStackView(.vertical)
    private let buttonsHStack = {
        let sv = UIStackView()
        sv.inset = .init(horizontal: 18) + .init(top: 20)
        sv.backgroundColor = .white
        sv.spacing = 8
        return sv
    }()

    private let imageView           = DetailImageView()
    private let infoSection         = DetailInfoSectionView()
    private let descriptionSection  = DetailDescriptionSectionView()
    private let artistSection       = DetailArtistSectionView()
    private let seatSection         = DetailSeatSectionView()
    private let noticeSection       = DetailNoticeSectionView()
    
    private let likeButton = LikeButton()
    private let applicationButton = {
        let button = TPButton(style: .filled, height: 48)
        button.setTitle("신청하기", .pretendard.bold(16))
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        navigationBar.titleLabel.config.text = "아티스트 공연 정보"
        imageView.image = .debugBusking // temp
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(scrollView)
        mainVStack.addArrangedSubview(buttonsHStack)
        
        scrollView.addSubview(contentVStack)
        buttonsHStack.addArrangedSubview(likeButton)
        buttonsHStack.addArrangedSubview(applicationButton)
        
        contentVStack.addArrangedSubview(imageView)
        contentVStack.addArrangedSubview(infoSection)
        contentVStack.addArrangedSubview(descriptionSection)
        contentVStack.addArrangedSubview(Divider(height: 1, color: .background))
        contentVStack.addArrangedSubview(artistSection)
        contentVStack.addArrangedSubview(Divider(height: 8, color: .background))
        contentVStack.addArrangedSubview(seatSection)
        contentVStack.addArrangedSubview(Divider(height: 1, color: .background))
        contentVStack.addArrangedSubview(noticeSection)
        
        likeButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        mainVStack.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
        contentVStack.snp.makeConstraints { $0.edges.width.equalToSuperview() }
        imageView.snp.makeConstraints { $0.size.equalTo(scrollView.snp.width) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {}
}

// MARK: - Preview

#Preview { PerformanceDetailVC() }

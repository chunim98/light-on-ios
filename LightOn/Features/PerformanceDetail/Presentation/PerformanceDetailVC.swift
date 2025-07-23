//
//  PerformanceDetailVC.swift
//  LightOn
//
//  Created by 신정욱 on 6/25/25.
//

import UIKit
import Combine

import CombineCocoa
import Kingfisher
import SnapKit

final class PerformanceDetailVC: BackButtonVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm: PerformanceDetailVM
    private var applyFlowCoord: PerformanceApplyFlowCoordinator?
    
    // MARK: Containers
    
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
    
    // MARK: Sections
    
    private let imageView           = DetailImageView()
    private let infoSection         = DetailInfoSectionView()
    private let descriptionSection  = DetailDescriptionSectionView()
    private let artistSection       = DetailArtistSectionView()
    private let seatSection         = DetailSeatSectionView()
    private let noticeSection       = DetailNoticeSectionView()
    
    // MARK: Buttons
    
    private let likeButton = LikeButton()
    
    private let applyButton = {
        let button = LOButton(style: .filled, height: 48)
        button.setTitle("신청하기", .pretendard.bold(16))
        return button
    }()
    
    // MARK: etc
    
    private let balloonView = {
        let view = TipBalloonView()
        view.setText(text: "무료공연으로 별도의 결제가 필요하지않아요!", highlighted: "무료공연")
        view.isUserInteractionEnabled = false
        return view
    }()
    
    // MARK: Life Cycle
    
    init(vm: PerformanceDetailVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        navigationBar.titleLabel.config.text = "아티스트 공연 정보"
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(scrollView)
        mainVStack.addArrangedSubview(buttonsHStack)
        mainVStack.addSubview(balloonView)
        
        scrollView.addSubview(contentVStack)
        buttonsHStack.addArrangedSubview(likeButton)
        buttonsHStack.addArrangedSubview(applyButton)
        
        contentVStack.addArrangedSubview(imageView)
        contentVStack.addArrangedSubview(infoSection)
        contentVStack.addArrangedSubview(descriptionSection)
        contentVStack.addArrangedSubview(LODivider(height: 1, color: .background))
        contentVStack.addArrangedSubview(artistSection)
        contentVStack.addArrangedSubview(LODivider(height: 8, color: .background))
        contentVStack.addArrangedSubview(seatSection)
        contentVStack.addArrangedSubview(LODivider(height: 1, color: .background))
        contentVStack.addArrangedSubview(noticeSection)
        
        likeButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        mainVStack.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
        contentVStack.snp.makeConstraints { $0.edges.width.equalToSuperview() }
        imageView.snp.makeConstraints { $0.size.equalTo(scrollView.snp.width) }
        balloonView.snp.makeConstraints {
            $0.bottom.equalTo(applyButton.snp.top).offset(-17)
            $0.centerX.equalTo(applyButton)
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let input = PerformanceDetailVM.Input(
            applyTap: applyButton.tapPublisher
        )
        
        let output = vm.transform(input)
        
        output.detailInfo
            .sink { [weak self] in self?.bindDetailInfo($0) }
            .store(in: &cancellables)
        
        output.applyEvent
            .sink { [weak self] in self?.bindStartApplyFlow($0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension PerformanceDetailVC {
    /// 공연 상세정보 값 바인딩
    private func bindDetailInfo(_ info: PerformanceDetailInfo) {
        // 썸네일 이미지
        let thumbnailURL = URL(string: info.thumbnailPath)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: thumbnailURL)
        // 기본 정보
        infoSection.genreTagLabel.config.text       = info.genre
        infoSection.titleLabel.config.text          = info.title
        infoSection.dateLabel.config.text           = info.date
        infoSection.timeLabel.config.text           = info.time
        infoSection.placeLabel.config.text          = info.place
        infoSection.priceLabel.config.text          = info.price
        // 아티스트 소개
        descriptionSection.descriptionLabel.config.text = info.description
        // 아티스트 정보
        artistSection.artistButton.setTitle(
            title: info.artistName,
            font:  .pretendard.regular(16),
            color: .brand
        )
        artistSection.descriptionLabel.config.text  = info.artistDescription
        // 좌석 정보
        seatSection.descriptionLabel.config.text    = info.seatDescription
        // 유의사항
        noticeSection.descriptionLabel.config.text  = info.noticeDescription
        // 팁 풍선 표시여부
        balloonView.isHidden                        = info.isPaid
    }
    
    /// 공연 신청 흐름 시작 바인딩
    private func bindStartApplyFlow(_ info: PerformanceDetailInfo) {
        applyFlowCoord = .init(navigation: navigationController!)
        info.isPaid // 유료, 무료 여부에 따라 다른 모달 표시
        ? applyFlowCoord?.showPaidEntryModalVC()
        : applyFlowCoord?.showFreeApplyModalVC()
    }
}

// MARK: - Preview

#Preview {
    PerformanceDetailVC(
        vm: PerformanceDetailDI.shared.makePerformanceDetailVM(performanceID: 12)
    )
}

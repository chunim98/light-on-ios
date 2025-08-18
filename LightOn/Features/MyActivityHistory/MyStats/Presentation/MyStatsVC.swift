//
//  MyStatsVC.swift
//  LightOn
//
//  Created by 신정욱 on 7/24/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class MyStatsVC: CombineVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = MyActivityHistoryDI.shared.makeMyStatsVM()
    
    // MARK: Components
    
    private let mainVStack = UIStackView(
        .vertical, inset: .init(horizontal: 18) + .init(top: 38, bottom: 24)
    )
    
    private let buttonHStack = UIStackView()
    
    private let imageView = UIImageView(image: .activityHistoryHeaderIllust)
    
    private let summaryLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.bold(23)
        config.foregroundColor = .loBlack
        config.paragraphSpacing = 2
        config.lineHeight = 32
        let label = LOLabel(config: config)
        label.numberOfLines = .max
        return label
    }()
    
    private let addLikingButton = {
        var titleConfig = AttrConfiguration()
        titleConfig.font = .pretendard.bold(14)
        titleConfig.foregroundColor = .white
        titleConfig.lineHeight = 32
        titleConfig.text = "취향 추가하기"
        var config = UIButton.Configuration.filled()
        config.attributedTitle = .init(config: titleConfig)
        config.contentInsets = .init(horizontal: 14)
        config.baseBackgroundColor = .brand
        config.cornerStyle = .capsule
        return UIButton(configuration: config)
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        view.backgroundColor = .xF5F0FF
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        mainVStack.addSubview(imageView)
        mainVStack.addArrangedSubview(summaryLabel)
        mainVStack.addArrangedSubview(LOSpacer(24))
        mainVStack.addArrangedSubview(buttonHStack)
        mainVStack.addArrangedSubview(LOSpacer())
        
        buttonHStack.addArrangedSubview(addLikingButton)
        buttonHStack.addArrangedSubview(LOSpacer())
        
        view.snp.makeConstraints { $0.height.equalTo(308) }
        mainVStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        imageView.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(21)
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let input = MyStatsVM.Input(loadTrigger: viewDidAppearPublisher)
        let output = vm.transform(input)
        
        output.myStatsInfo
            .sink { [weak self] in self?.bindStatsInfo($0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension MyStatsVC {
    /// 활동 통계 바인딩
    private func bindStatsInfo(_ info: MyStatsInfo) {
        summaryLabel.config.text = """
        \(info.name)님의
        공연 참가 수는 \(info.applyCount)회
        주요 활동 장소는 \(info.place) 입니다
        """
        summaryLabel.addAnyAttribute(
            name: .foregroundColor,
            value: UIColor.brand,
            segment: "\(info.applyCount)회"
        )
        summaryLabel.addAnyAttribute(
            name: .foregroundColor,
            value: UIColor.brand,
            segment: info.place
        )
    }
}

// MARK: - Preview

#Preview { MyStatsVC() }


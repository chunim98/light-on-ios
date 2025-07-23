//
//  BannerVC.swift
//  LightOn
//
//  Created by 신정욱 on 5/13/25.
//

import UIKit
import Combine

import Kingfisher
import SnapKit

final class BannerVC: UIViewController {
    
    // MARK: Properties
    
    private let bannerItem: PerformanceBannerItem
    
    // MARK: Components
    
    private let tapGesture = UITapGestureRecognizer()
    
    private let mainVStack = UIStackView(
        .vertical, spacing: 8, inset: .init(horizontal: 30) + .init(bottom: 60)
    )
    
    private let imageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .xC5C5C5
        iv.clipsToBounds = true
        return iv
    }()
    
    private let gradientView = GradientView()
    
    private let titleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.bold(28)
        config.foregroundColor = .white
        config.paragraphSpacing = 12
        config.lineHeight = 36
        
        let label = LOLabel(config: config)
        label.numberOfLines = 2
        return label
    }()
    
    private let descriptionLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.regular(18)
        config.foregroundColor = .white
        config.lineHeight = 27
        return LOLabel(config: config)
    }()
    
    // MARK: Life Cycle
    
    init(item: PerformanceBannerItem) {
        self.bannerItem = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        view.addGestureRecognizer(tapGesture)
        
        let imageURL = URL(string: bannerItem.imagePath)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: imageURL)
        
        titleLabel.config.text = bannerItem.title
        descriptionLabel.config.text = bannerItem.description
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(imageView)
        view.addSubview(gradientView)
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(titleLabel)
        mainVStack.addArrangedSubview(descriptionLabel)
        
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        gradientView.snp.makeConstraints { $0.edges.equalTo(mainVStack) }
        mainVStack.snp.makeConstraints { $0.horizontalEdges.bottom.equalToSuperview() }
    }
}

// MARK: Binders & Publishers

extension BannerVC {
    /// 배너 탭 & 공연 아이디 퍼블리셔
    var tapWithIDPublsisher: AnyPublisher<Int, Never> {
        tapGesture.tapPublisher
            .map { [bannerItem] _ in bannerItem.performanceID  }
            .eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview(traits: .fixedLayout(width: 402, height: 402)) {
    BannerVC(item: .init(
        performanceID: 0,
        imagePath: "",
        title: "",
        description: ""
    ))
}
#Preview { HomeVC() }


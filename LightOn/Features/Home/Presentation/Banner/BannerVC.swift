//
//  BannerVC.swift
//  LightOn
//
//  Created by 신정욱 on 5/13/25.
//

import UIKit
import Combine

import SnapKit

final class BannerVC: UIViewController {
    
    // MARK: Components
    
    private let tapGesture = UITapGestureRecognizer()
    
    private let mainVStack = UIStackView(
        .vertical,
        spacing: 8,
        inset: .init(horizontal: 30) + .init(bottom: 60)
    )
    
    private let imageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(hex: 0xC5C5C5)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let gradientView = BannerGradientView()
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .pretendard.bold(28)
        label.textColor = .loWhite
        label.numberOfLines = 2
        return label
    }()
    
    private let subTitleLabel = {
        let label = UILabel()
        label.font = .pretendard.regular(18)
        label.textColor = .loWhite
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: Life Cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(item: any BannerItem) {
        self.init(nibName: nil, bundle: nil)
        self.imageView.image    = item.image
        self.titleLabel.text    = item.title
        self.subTitleLabel.text = item.subTitle
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(tapGesture)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(imageView)
        view.addSubview(gradientView)
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(titleLabel)
        mainVStack.addArrangedSubview(subTitleLabel)
        
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        gradientView.snp.makeConstraints { $0.edges.equalTo(mainVStack) }
        mainVStack.snp.makeConstraints { $0.horizontalEdges.bottom.equalToSuperview() }
    }
    
    // MARK: Public Configuration
    
    func configure(item: any BannerItem) {
        imageView.image    = item.image
        titleLabel.text    = item.title
        subTitleLabel.text = item.subTitle
    }
}

// MARK: Binders & Publishers

extension BannerVC {
    var tapGesturePublisher: AnyPublisher<Void, Never> {
        tapGesture.publisher().map { _ in }.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview(traits: .fixedLayout(width: 402, height: 402)) { BannerVC() }


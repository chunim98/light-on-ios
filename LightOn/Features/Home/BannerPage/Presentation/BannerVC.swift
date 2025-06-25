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
    
    let tapGesture = UITapGestureRecognizer()
    
    private let mainVStack =
    UIStackView(.vertical, spacing: 8, inset: .init(horizontal: 30) + .init(bottom: 60))
    
    private let imageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .xC5C5C5
        iv.clipsToBounds = true
        return iv
    }()
    
    private let gradientView = GradientView()
    
    private let titleLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.bold(28)
        config.foregroundColor = .white
        config.paragraphSpacing = 12
        config.lineHeight = 36
        
        let label = LOLabel(config: config)
        label.numberOfLines = 2
        return label
    }()
    
    private let subTitleLabel = {
        var config = TextConfiguration()
        config.font = .pretendard.regular(18)
        config.foregroundColor = .white
        config.lineHeight = 27
        return LOLabel(config: config)
    }()
    
    // MARK: Life Cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(item: BannerItem) {
        self.init(nibName: nil, bundle: nil)
        self.imageView.image    = item.image
        self.titleLabel.config.text = item.title
        self.subTitleLabel.config.text = item.subTitle
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        view.addGestureRecognizer(tapGesture)
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
    
    func configure(item: BannerItem) {
        imageView.image    = item.image
        titleLabel.config.text = item.title
        subTitleLabel.config.text = item.subTitle
    }
}

// MARK: - Preview

#Preview(traits: .fixedLayout(width: 402, height: 402)) { BannerVC() }
#Preview { HomeVC() }


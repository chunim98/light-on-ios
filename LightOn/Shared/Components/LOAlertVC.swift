//
//  LOAlertVC.swift
//  LightOn
//
//  Created by 신정욱 on 5/2/25.
//

import UIKit

import SnapKit

final class LOAlertVC: UIViewController {
    
    // MARK: Components
    
    private let contentView = {
        let sv = UIStackView(.vertical)
        sv.spacing = 28
        sv.clipsToBounds = true
        sv.layer.cornerRadius = 8
        sv.backgroundColor = .loWhite
        sv.inset = .init(horizontal: 18, vertical: 28)
        return sv
    }()
    
    private let detailContainer = UIStackView(.vertical, alignment: .center, spacing: 8)
    
    private let headerLabel = {
        let label = UILabel()
        label.text = "제목" // temp
        label.textColor = .loBlack
        label.font = .pretendard.bold(22)
        return label
    }()
    
    private let bodyView: UIView
    
    private let buttonContainer = UIStackView(spacing: 8)
    
    private let cancelButton = {
        let button = LOButton(style: .bordered)
        button.attributedTitle = .init("취소", .pretendard.regular(16)) // temp
        return button
    }()
    
    private let acceptButton = {
        let button = LOButton(style: .filled)
        button.attributedTitle = .init("확인", .pretendard.semiBold(16)) // temp
        return button
    }()
    
    // MARK: Life Cycle
    
    init(content: UIView) {
        self.bodyView = content
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .loBlack.withAlphaComponent(0.6)
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        view.addSubview(contentView)
        contentView.addArrangedSubview(detailContainer)
        contentView.addArrangedSubview(buttonContainer)
        detailContainer.addArrangedSubview(headerLabel)
        detailContainer.addArrangedSubview(bodyView)
        buttonContainer.addArrangedSubview(cancelButton)
        buttonContainer.addArrangedSubview(acceptButton)
        
        contentView.snp.makeConstraints {
            $0.center.equalTo(view.safeAreaLayoutGuide)
            $0.height.lessThanOrEqualTo(520)
            $0.width.equalTo(345)
        }
    }
}

#Preview {
    let label = UILabel()
    label.font = .pretendard.regular(18)
    label.textColor = .caption
    label.textAlignment = .center
    label.text = "이건 일단 내용입니다.\n딱히 뭐 적을 게 없네여.." // temp
    label.numberOfLines = .max
    return LOAlertVC(content: label)
}

//
//  LOAlertVC.swift
//  LightOn
//
//  Created by 신정욱 on 5/2/25.
//

import UIKit
import Combine

import SnapKit

final class LOAlertVC: UIViewController {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private weak var base: UIViewController?
    private let isCancelButtonHidden: Bool
    
    // MARK: Components
    
    private let contentView = {
        let sv = UIStackView(.vertical, spacing: 28)
        sv.clipsToBounds = true
        sv.layer.cornerRadius = 8
        sv.backgroundColor = .white
        sv.inset = .init(horizontal: 18, vertical: 28)
        return sv
    }()
    
    private let detailContainer = UIStackView(.vertical, alignment: .center, spacing: 8)
    
    private let headerLabel = {
        let label = UILabel()
        label.textColor = .loBlack
        label.font = .pretendard.bold(22)
        return label
    }()
    
    private let bodyView: UIView
    private let buttonContainer = UIStackView(spacing: 8)
    private let cancelButton = LOButton(style: .bordered)
    private let acceptButton = LOButton(style: .filled)
    
    // MARK: Life Cycle

    init(
        base: UIViewController?,
        content: UIView,
        headerTitle: String,
        acceptTitle: String,
        cancelTitle: String? = nil
    ) {
        // 이 얼럿을 띄워 줄 뷰컨 인스턴스 받아오기
        self.base = base
        // 얼럿 내용
        self.bodyView = content
        // 헤더 제목
        self.headerLabel.text = headerTitle
        // 확인 버튼 제목
        self.acceptButton.setTitle(acceptTitle, .pretendard.semiBold(16))
        // 취소 버튼 제목(사용 시)
        if let cancelTitle {
            self.cancelButton.setTitle(cancelTitle, .pretendard.regular(16))
        }
        // 취소 버튼 표시 여부
        self.isCancelButtonHidden = (cancelTitle == nil)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .loBlack.withAlphaComponent(0.6)
        setupLayout()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(contentView)
        contentView.addArrangedSubview(detailContainer)
        contentView.addArrangedSubview(buttonContainer)
        detailContainer.addArrangedSubview(headerLabel)
        detailContainer.addArrangedSubview(bodyView)
        // 취소 버튼 제목을 지정하지 않으면, 사용하지 않는 것으로 간주하고 숨김
        if !isCancelButtonHidden { buttonContainer.addArrangedSubview(cancelButton) }
        buttonContainer.addArrangedSubview(acceptButton)
        
        contentView.snp.makeConstraints {
            $0.center.equalTo(view.safeAreaLayoutGuide)
            $0.height.lessThanOrEqualTo(520)
            $0.width.equalTo(345)
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        acceptButton.tapPublisher
            .sink { [weak self] _ in self?.dismiss(animated: true) }
            .store(in: &cancellables)
        
        cancelButton.tapPublisher
            .sink { [weak self] _ in self?.dismiss(animated: true) }
            .store(in: &cancellables)
    }
    
    // MARK: Methods
    
    func show() {
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        base?.present(self, animated: true)
    }
}

// MARK: Binders & Publishers

extension LOAlertVC {
    var acceptEventPublisher: AnyPublisher<Void, Never> {
        self.acceptButton.tapPublisher
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    var cancelEventPublisher: AnyPublisher<Void, Never> {
        self.cancelButton.tapPublisher
            .map { _ in }
            .eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview {
    let label = UILabel()
    label.textColor = .caption
    label.numberOfLines = .max
    label.textAlignment = .center
    label.font = .pretendard.regular(18)
    label.text = "이건 일단 내용입니다.\n딱히 뭐 적을 게 없네여.."

    return LOAlertVC(
        base: nil,
        content: label,
        headerTitle: "호고곡..",
        acceptTitle: "확인"
    )
}

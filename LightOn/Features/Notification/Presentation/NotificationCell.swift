//
//  NotificationCell.swift
//  LightOn
//
//  Created by 신정욱 on 5/13/25.
//

import UIKit

import SnapKit

final class NotificationCell: UITableViewCell {
    
    // MARK: Enum
    
    enum NotificationType: String {
        case notice      = "공지사항"
        case performance = "공연알림"
        case event       = "이벤트"
        
        var icon: UIImage {
            switch self {
            case .notice:      .notificationCalendar
            case .performance: .notificationBell
            case .event:       .notificationStar
            }
        }
        var title: String { self.rawValue }
    }
    
    // MARK: Properties
    
    static let id = "NotificationCell"
    
    // MARK: Components
    
    private let mainHStack = UIStackView(alignment: .top, spacing: 8, inset: .init(edges: 18))
    private let detailVStack = UIStackView(.vertical, spacing: 6)
    private let titleAndTimeHStack = UIStackView()
    private let readMoreHStack = UIStackView()
    
    private let iconView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .pretendard.semiBold(14)
        label.textColor = .caption
        return label
    }()
    
    private let elapsedTimeLabel = {
        let label = UILabel()
        label.font = .pretendard.regular(14)
        label.textColor = .clickable
        return label
    }()
    
    private let descriptionLabel = {
        let label = UILabel()
        label.font = .pretendard.semiBold(16)
        label.textColor = .loBlack
        label.numberOfLines = 2
        return label
    }()
    
    private let readMoreButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = .init("더보기", .pretendard.regular(14))
        config.baseForegroundColor = .clickable
        config.contentInsets = .zero
        return UIButton(configuration: config)
    }()
    
    // MARK: Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(item: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.addSubview(mainHStack)
        mainHStack.addArrangedSubview(iconView)
        mainHStack.addArrangedSubview(detailVStack)
        detailVStack.addArrangedSubview(titleAndTimeHStack)
        detailVStack.addArrangedSubview(descriptionLabel)
        detailVStack.addArrangedSubview(readMoreHStack)
        titleAndTimeHStack.addArrangedSubview(titleLabel)
        titleAndTimeHStack.addArrangedSubview(UIView())
        titleAndTimeHStack.addArrangedSubview(elapsedTimeLabel)
        readMoreHStack.addArrangedSubview(readMoreButton)
        readMoreHStack.addArrangedSubview(UIView())
        
        iconView.setContentHuggingPriority(.init(999), for: .horizontal)
        
        mainHStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        iconView.snp.makeConstraints { $0.size.equalTo(20) }
    }
    
    // MARK: Public Configuration

    func configure(item: NotificationItem?) {
        iconView.image        = item?.notificationType.icon
        titleLabel.text       = item?.notificationType.title
        elapsedTimeLabel.text = item?.elapsedTimeText
        descriptionLabel.text = item?.descriptionText
    }
}

// MARK: - Preview

#Preview { NotificationCell() }

//
//  LOIconLabel.swift
//  LightOn
//
//  Created by 신정욱 on 5/5/25.
//

import UIKit

import SnapKit

final class LOIconLabel: UIView {
    
    // MARK: Enum
    
    enum IconPlacement {
        case front
        case rear
    }
    
    // MARK: Properties
    
    private let iconPlacement: IconPlacement
    
    // MARK: Components
    
    private let mainHStack = UIStackView(alignment: .center)
    private let iconView = {
        let imageView = UIImageView()
        imageView.tintColor = .loBlack
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let label = {
        let label = UILabel()
        label.textColor = .loBlack
        return label
    }()
    
    // MARK: Life Cycle
    
    init(iconIn iconPlacement: IconPlacement = .front) {
        self.iconPlacement = iconPlacement
        super.init(frame: .zero)

        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        self.addSubview(mainHStack)
        
        if iconPlacement == .front {
            mainHStack.addArrangedSubview(iconView)
            mainHStack.addArrangedSubview(label)
        } else {
            mainHStack.addArrangedSubview(label)
            mainHStack.addArrangedSubview(iconView)
        }
        
        iconView.setContentHuggingPriority(.init(999), for: .horizontal)
        
        mainHStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Configuration
    
    /// 아이콘 설정 후에 사용해야 유효함.
    func setColor(_ color: UIColor) {
        label.textColor = color
        iconView.image = iconView.image?.withTintColor(color)
    }
    
    var icon: UIImage? {
        get { iconView.image }
        set { iconView.image = newValue }
    }
    
    var text: String? {
        get { label.text }
        set { label.text = newValue}
    }
    
    var font: UIFont {
        get { label.font }
        set { label.font = newValue }
    }
    
    var spacing: CGFloat {
        get { mainHStack.spacing }
        set { mainHStack.spacing = newValue }
    }
}

#Preview {
    let iconLabel = LOIconLabel(iconIn: .front)
    iconLabel.icon = UIImage(named: "event_card_cell_clock")
    iconLabel.font = .pretendard.regular(12)
    iconLabel.text = "2025.05.01"
    iconLabel.setColor(.brand)
    iconLabel.spacing = 6
    return iconLabel
}

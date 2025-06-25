//
//  LOIconLabel.swift
//  LightOn
//
//  Created by 신정욱 on 5/5/25.
//

import UIKit

class LOIconLabel: UIStackView {
    
    // MARK: Enum
    
    enum IconPlacement {
        case front
        case rear
    }
    
    // MARK: Properties
    
    private let iconPlacement: IconPlacement
    
    // MARK: Components
    
    private let imageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .loBlack
        return iv
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
        setupDefaults()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() { alignment = .center }
    
    // MARK: Layout
    
    private func setupLayout() {
        if iconPlacement == .front {
            addArrangedSubview(imageView)
            addArrangedSubview(label)
        } else {
            addArrangedSubview(label)
            addArrangedSubview(imageView)
        }
        
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    // MARK: Configuration
    
    /// 아이콘 설정 후에 사용해야 유효함.
    func setColor(_ color: UIColor) {
        label.textColor = color
        imageView.image = imageView.image?.withTintColor(color)
    }
    
    func setIcon(_ image: UIImage?) { imageView.image = image }
    func setTextColor(_ color: UIColor?) { label.textColor = color }
    func setText(_ text: String?) { label.text = text }
    func setFont(_ font: UIFont?) { label.font = font }
}

// MARK: - Preview

#Preview {
    let iconLabel = LOIconLabel(iconIn: .front)
    iconLabel.setIcon(UIImage(named: "event_card_cell_clock"))
    iconLabel.setFont(.pretendard.regular(12))
    iconLabel.setText("2025.05.01")
    iconLabel.setColor(.brand)
    iconLabel.spacing = 6
    return iconLabel
}

//
//  LOLabel.swift
//  LightOn
//
//  Created by 신정욱 on 5/21/25.
//

import UIKit

class LOLabel: UILabel {

    // MARK: Properties
    
    var config: TextConfiguration { didSet { setupDefaults() } }
    private var attrStr: NSMutableAttributedString?
    
    // MARK: Life Cycle
    
    init(config: TextConfiguration) {
        self.config = config
        super.init(frame: .zero)
        setupDefaults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        attrStr = NSMutableAttributedString(textConfig: config)
        attributedText = attrStr
    }
    
    // MARK: Public Configuration
    
    /// 해당 메서드를 통해 적용한 효과는 소급 적용되지 않음 (config 구성을 마친 후 가장 마지막에 적용할 것)
    func addAnyAttribute(name: NSAttributedString.Key, value: Any) {
        guard let full = config.text else { return }
        
        let range = NSString(string: full).range(of: full)
        attrStr?.addAttribute(name, value: value, range: range)
        attributedText = attrStr
    }
    
    /// 해당 메서드를 통해 적용한 효과는 소급 적용되지 않음 (config 구성을 마친 후 가장 마지막에 적용할 것)
    func addAnyAttribute(name: NSAttributedString.Key, value: Any, segment: String) {
        guard let full = config.text else { return }
        
        let range = NSString(string: full).range(of: segment)
        attrStr?.addAttribute(name, value: value, range: range)
        attributedText = attrStr
    }
}

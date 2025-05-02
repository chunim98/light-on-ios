//
//  AttributeContainer+.swift
//  LightOn
//
//  Created by 신정욱 on 5/2/25.
//

import Foundation

extension AttributeContainer {
    static let bold16 = {
        var container = AttributeContainer()
        container.font = .boldSystemFont(ofSize: 16)
        return container
    }()
}

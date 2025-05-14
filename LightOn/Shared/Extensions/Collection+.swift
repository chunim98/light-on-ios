//
//  Collection+.swift
//  LightOn
//
//  Created by 신정욱 on 5/15/25.
//

import Foundation

extension Collection {
    subscript (safe i: Index) -> Iterator.Element? {
        self.indices.contains(i) ? self[i] : nil
    }
}

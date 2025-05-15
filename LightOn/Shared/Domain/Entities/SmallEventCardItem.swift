//
//  SmallEventCardItem.swift
//  LightOn
//
//  Created by 신정욱 on 5/12/25.
//

import UIKit

protocol SmallEventCardItem: Hashable {
    var thumbnail: UIImage { get }
    var title: String { get }
}

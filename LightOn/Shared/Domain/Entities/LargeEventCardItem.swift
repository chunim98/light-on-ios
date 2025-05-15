//
//  LargeEventCardItem.swift
//  LightOn
//
//  Created by 신정욱 on 5/12/25.
//

import UIKit

protocol LargeEventCardItem: Hashable {
    var thumbnail: UIImage { get }
    var title: String { get }
    var date: String { get }
    var time: String { get }
    var location: String { get }
}

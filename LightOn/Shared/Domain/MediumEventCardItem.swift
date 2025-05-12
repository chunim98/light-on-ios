//
//  MediumEventCardItem.swift
//  LightOn
//
//  Created by 신정욱 on 5/12/25.
//

import UIKit

protocol MediumEventCardItem: Hashable {
    var thumbnail: UIImage { get }
    var artist: String { get }
    var title: String { get }
    var genre: String { get }
    var date: String { get }
    var time: String { get }
    var location: String { get }
}

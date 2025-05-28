//
//  BannerItem.swift
//  LightOn
//
//  Created by 신정욱 on 5/13/25.
//

import UIKit

protocol BannerItem {
    var image: UIImage   { get }
    var title: String    { get }
    var subTitle: String { get }
}

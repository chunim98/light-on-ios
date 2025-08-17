//
//  LargePerformanceCellItem.swift
//  LightOn
//
//  Created by 신정욱 on 5/12/25.
//

import UIKit

struct LargePerformanceCellItem: Hashable {
    let performanceID: Int
    let thumbnailPath: String?
    let title: String
    let date: String
    let time: String
    let location: String
}

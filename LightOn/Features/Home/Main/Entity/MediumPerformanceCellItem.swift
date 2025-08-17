//
//  MediumPerformanceCellItem.swift
//  LightOn
//
//  Created by 신정욱 on 5/12/25.
//

import UIKit

struct MediumPerformanceCellItem: Hashable {
    let performanceID: Int
    let thumbnailPath: String?
    let artist: String
    let title: String
    let genre: String
    let date: String
    let time: String
    let location: String
}

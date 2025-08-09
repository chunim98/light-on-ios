//
//  MyPerformanceCellItem.swift
//  LightOn
//
//  Created by 신정욱 on 8/8/25.
//

import UIKit

struct MyPerformanceCellItem: Hashable {
    let id: Int
    let title: String
    let type: String
    let date: String
    let time: String
    let place: String
    let publishedAt: String
    let style: MyPerformanceCellStyle
}

//
//  HashtagPerformanceCellItem.swift
//  LightOn
//
//  Created by 신정욱 on 6/11/25.
//

import UIKit

struct HashtagPerformanceCellItem: Hashable {
    let id: Int
    let thumbnailPath: String?
    let typeLabelHidden: Bool
    let hashtag: String
    let title: String
    let place: String
    let date: String
}

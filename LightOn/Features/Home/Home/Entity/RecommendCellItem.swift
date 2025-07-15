//
//  RecommendCellItem.swift
//  LightOn
//
//  Created by 신정욱 on 5/12/25.
//

import UIKit

struct RecommendCellItem: Hashable {
    let performanceID: Int
    let thumbnailPath: String?
    let title: String

    static let mockItems: [RecommendCellItem] = [
        .init(performanceID: 0, thumbnailPath: nil, title: "[홍대] Light ON 홀리데이 버스킹"),
        .init(performanceID: 0, thumbnailPath: nil, title: "[잠실] Light ON 홀리데이 버스킹"),
        .init(performanceID: 0, thumbnailPath: nil, title: "[여의도] Light ON 홀리데이 버스킹"),
        .init(performanceID: 0, thumbnailPath: nil, title: "[우리집] Light ON 홀리몰리 버스킹")
    ]
}

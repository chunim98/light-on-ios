//
//  RecommendCellItem.swift
//  LightOn
//
//  Created by 신정욱 on 5/12/25.
//

import UIKit

struct RecommendCellItem: Hashable {
    let thumbnail: UIImage
    let title: String
    
    static let mockItems: [RecommendCellItem] = [
        .init(thumbnail: .debugBusking, title: "[홍대] Light ON 홀리데이 버스킹"),
        .init(thumbnail: .debugBusking2, title: "[잠실] Light ON 홀리데이 버스킹"),
        .init(thumbnail: .debugBusking, title: "[여의도] Light ON 홀리데이 버스킹"),
        .init(thumbnail: .debugBusking2, title: "[우리집] Light ON 홀리몰리 버스킹")
    ]
}

//
//  BannerItem.swift
//  LightOn
//
//  Created by 신정욱 on 5/13/25.
//

import UIKit

struct BannerItem {
    let image: UIImage
    let title: String
    let subTitle: String
    
    static let mockItems: [BannerItem] = [
        .init(
            image: .debugBusking,
            title: "5월의 특별한 공연",
            subTitle: "야외에서 즐기는 라이브 버스킹!"
        ),
        .init(
            image: .debugBusking2,
            title: "버스킹 나잇 마켓",
            subTitle: "공연과 함께하는 플리마켓"
        ),
        .init(
            image: .debugBusking,
            title: "주말 저녁, 음악 한 잔",
            subTitle: "도심 속 힐링 버스킹 초대장"
        )
    ]
}

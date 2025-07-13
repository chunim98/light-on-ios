//
//  PopularCellItem.swift
//  LightOn
//
//  Created by 신정욱 on 5/12/25.
//

import UIKit

struct PopularCellItem: Hashable {
    let thumbnail: UIImage
    let title: String
    let date: String
    let time: String
    let location: String
    
    static let mockItems: [PopularCellItem] = [
        .init(
            thumbnail: .debugBusking,
            title: "2025 서울 봄 버스킹 페스티벌",
            date: "2025.05.10",
            time: "16:00",
            location: "서울 광진구 능동로 209 (어린이대공원 야외무대)"
        ),
        .init(
            thumbnail: .debugBusking2,
            title: "한강 뮤직 나잇",
            date: "2025.05.12",
            time: "19:00",
            location: "서울 영등포구 여의동로 330 (여의도 한강공원)"
        ),
        .init(
            thumbnail: .debugBusking,
            title: "밤하늘 재즈 페스티벌",
            date: "2025.05.15",
            time: "20:00",
            location: "서울 성동구 서울숲 2길 8-1"
        ),
        .init(
            thumbnail: .debugBusking2,
            title: "강남 스트리트 퍼포먼스",
            date: "2025.05.18",
            time: "18:30",
            location: "서울 강남구 강남대로 396"
        )
    ]
}

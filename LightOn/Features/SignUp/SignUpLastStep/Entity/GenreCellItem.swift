//
//  GenreCellItem.swift
//  LightOn
//
//  Created by 신정욱 on 5/30/25.
//

import UIKit

struct GenreCellItem: DropdownCellItem {
    let id: Int
    let title: String
    let image: UIImage
    let isSelected: Bool
    
    /// isSelected 상태 토글
    func toggleSelected() -> GenreCellItem {
        GenreCellItem(
            id: self.id,
            title: self.title,
            image: self.image,
            isSelected: !self.isSelected
        )
    }
    
    /// 사전 정의된 장르 데이터
    static let genres: [GenreCellItem] = [
        .init(id: 1, title: "팝", image: .genreBadgePop, isSelected: false),
        .init(id: 2, title: "록", image: .genreBadgeRock, isSelected: false),
        .init(id: 3, title: "힙합", image: .genreBadgeHipHop, isSelected: false),
        .init(id: 4, title: "R&B", image: .genreBadgeRnB, isSelected: false),
        .init(id: 5, title: "EDM", image: .genreBadgeEDM, isSelected: false),
        .init(id: 6, title: "발라드", image: .genreBadgeBallad, isSelected: false),
        .init(id: 7, title: "재즈", image: .genreBadgeJazz, isSelected: false),
        .init(id: 8, title: "클래식", image: .genreBadgeClassic, isSelected: false),
        .init(id: 9, title: "레게", image: .genreBadgeReggae, isSelected: false),
        .init(id: 11, title: "컨트리", image: .genreBadgeCountry, isSelected: false),
        .init(id: 13, title: "어쿠스틱", image: .genreBadgeAcoustic, isSelected: false),
        .init(id: 12, title: "얼터너티브", image: .genreBadgeAlternative, isSelected: false),
        .init(id: 15, title: "기타", image: .genreBadgeEtc, isSelected: false),
    ]
}














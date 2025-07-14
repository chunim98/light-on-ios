//
//  Genre.swift
//  LightOn
//
//  Created by 신정욱 on 7/14/25.
//

struct Genre {
    let id: Int
    let name: String
    
    /// 사전 정의된 장르 데이터
    static let items: [Genre] = [
        .init(id: 1, name: "팝"),
        .init(id: 2, name: "록"),
        .init(id: 3, name: "힙합"),
        .init(id: 4, name: "R&B"),
        .init(id: 5, name: "EDM"),
        .init(id: 6, name: "발라드"),
        .init(id: 7, name: "재즈"),
        .init(id: 8, name: "클래식"),
        .init(id: 9, name: "레게"),
        .init(id: 11, name: "컨트리"),
        .init(id: 13, name: "어쿠스틱"),
        .init(id: 12, name: "얼터너티브"),
        .init(id: 15, name: "기타")
    ]
}

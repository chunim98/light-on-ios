//
//  BankCellItem.swift
//  LightOn
//
//  Created by 신정욱 on 7/13/25.
//

struct BankCellItem: DropdownCellItem {
    let title: String
    
    static let banks: [BankCellItem] = [
        .init(title: "카카오뱅크"), .init(title: "기업은행"),
        .init(title: "신한은행"), .init(title: "국민은행"),
        .init(title: "농협은행"), .init(title: "우리은행"),
        .init(title: "하나은행"), .init(title: "케이뱅크"),
        .init(title: "토스뱅크"), .init(title: "산업은행"),
        .init(title: "SC제일은행"), .init(title: "IM뱅크"),
        .init(title: "우체국"), .init(title: "새마을금고"),
        .init(title: "신협중앙회"), .init(title: "전북은행"),
        .init(title: "경남은행"), .init(title: "부산은행"),
        .init(title: "광주은행"), .init(title: "수협은행"),
        .init(title: "제주은행")
    ]
}

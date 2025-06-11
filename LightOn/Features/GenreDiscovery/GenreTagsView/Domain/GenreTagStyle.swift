//
//  GenreTagStyle.swift
//  LightOn
//
//  Created by 신정욱 on 6/11/25.
//

import UIKit

struct GenreTagStyle {
    let font: UIFont
    let foregroundColor: UIColor
    let backgroundColor: UIColor
    let strokeColor: UIColor
        
    static var selected: GenreTagStyle {
        GenreTagStyle(
            font: .pretendard.bold(15),
            foregroundColor: .white,
            backgroundColor: .loBlack,
            strokeColor: .clear
        )
    }
    
    static var normal: GenreTagStyle {
        GenreTagStyle(
            font: .pretendard.regular(15),
            foregroundColor: .assistive,
            backgroundColor: .clear,
            strokeColor: .assistive
        )
    }
}

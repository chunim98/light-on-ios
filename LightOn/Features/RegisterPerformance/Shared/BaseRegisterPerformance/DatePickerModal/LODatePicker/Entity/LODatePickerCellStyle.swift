//
//  LODatePickerCellStyle.swift
//  LightOn
//
//  Created by 신정욱 on 8/20/25.
//

import UIKit

struct LODatePickerCellStyle {
    
    let backgroundColor: UIColor?
    
    let selectionColor: UIColor?
    let selectionCornerRadius: CGFloat
    let selectionBorderWidth: CGFloat
    let selectionBorderColor: UIColor?
    
    let dateColor: UIColor?
    let dateFont: UIFont?
    
    init(_ selection: LODatePickerCellSelection) {
        switch selection {
        case .default:
            backgroundColor = .clear
            selectionColor = .clear
            selectionCornerRadius = 0
            selectionBorderWidth = 0
            selectionBorderColor = nil
            dateColor = .caption
            dateFont = .pretendard.regular(18)
            
        case .single:
            backgroundColor = .clear
            selectionColor = .brand
            selectionCornerRadius = 17.5
            selectionBorderWidth = 0
            selectionBorderColor = nil
            dateColor = .white
            dateFont = .pretendard.semiBold(18)
            
        case .start:
            backgroundColor = .xF5F0FF
            selectionColor = .brand
            selectionCornerRadius = 17.5
            selectionBorderWidth = 0
            selectionBorderColor = nil
            dateColor = .white
            dateFont = .pretendard.semiBold(18)
            
        case .end:
            backgroundColor = .xF5F0FF
            selectionColor = .white
            selectionCornerRadius = 17.5
            selectionBorderWidth = 1
            selectionBorderColor = .brand
            dateColor = .brand
            dateFont = .pretendard.semiBold(18)
            
        case .inRange:
            backgroundColor = .xF5F0FF
            selectionColor = .clear
            selectionCornerRadius = 0
            selectionBorderWidth = 0
            selectionBorderColor = nil
            dateColor = .caption
            dateFont = .pretendard.regular(18)
        }
    }
}

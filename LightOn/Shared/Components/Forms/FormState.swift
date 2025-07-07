//
//  FormState.swift
//  LightOn
//
//  Created by 신정욱 on 7/7/25.
//

protocol FormState {
    var isEditing: Bool { get }
    var isValid: Bool { get }
    var isEmpty: Bool { get }
}

extension FormState {
    /// 폼 상태에서 스타일 추출
    var styleFlag: FormStyleFlag {
        guard isValid else { return .invalid }
        if isEditing { return .editing }
        if isEmpty { return .empty }
        return .filled
    }
}

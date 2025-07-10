//
//  CounterTextFormState 2.swift
//  LightOn
//
//  Created by 신정욱 on 7/10/25.
//


struct CounterTextFormState {
    let isEditing: Bool
    let isValid: Bool
    let isEmpty: Bool
    
    let text: String
    let maxByte: Int
    var nowByte: Int { text.count }
    
    func updated(
        isEditing: Bool? = nil,
        isValid: Bool? = nil,
        isEmpty: Bool? = nil,
        text: String? = nil
    ) -> CounterTextFormState {
        .init(
            isEditing: isEditing ?? self.isEditing,
            isValid: isValid ?? self.isValid,
            isEmpty: isEmpty ?? self.isEmpty,
            text: text ?? self.text,
            maxByte: self.maxByte
        )
    }
    
    /// 스타일 맵핑
    func toStyle() -> CounterTextFormStyle {
        guard isValid else { return .error }
        if isEditing { return .focused }
        if isEmpty { return .idle }
        return .filled
    }
}
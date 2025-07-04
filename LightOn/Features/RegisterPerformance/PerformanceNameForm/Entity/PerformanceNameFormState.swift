//
//  PerformanceNameFormState.swift
//  LightOn
//
//  Created by 신정욱 on 7/5/25.
//

struct PerformanceNameFormState {
    let text: String
    let byte: Int
    let isEditing: Bool
    let style: PerformanceNameFormStyle
    
    func updated(
        text: String? = nil,
        byte: Int? = nil,
        isEditing: Bool? = nil,
        style: PerformanceNameFormStyle? = nil
    ) -> PerformanceNameFormState {
        return .init(
            text: text ?? self.text,
            byte: byte ?? self.byte,
            isEditing: isEditing ?? self.isEditing,
            style: style ?? self.style
        )
    }
}

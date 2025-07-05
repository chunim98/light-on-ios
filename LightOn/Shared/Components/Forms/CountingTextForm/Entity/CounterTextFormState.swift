//
//  CounterTextFormState.swift
//  LightOn
//
//  Created by 신정욱 on 7/5/25.
//

struct CounterTextFormState {
    let text: String
    let byte: Int
    let maxByte: Int
    let isEditing: Bool
    let style: CounterTextFormStyle
    
    func updated(
        text: String? = nil,
        byte: Int? = nil,
        isEditing: Bool? = nil,
        style: CounterTextFormStyle? = nil
    ) -> CounterTextFormState {
        return .init(
            text: text ?? self.text,
            byte: byte ?? self.byte,
            maxByte: self.maxByte,  // 수정 안 함
            isEditing: isEditing ?? self.isEditing,
            style: style ?? self.style
        )
    }
}

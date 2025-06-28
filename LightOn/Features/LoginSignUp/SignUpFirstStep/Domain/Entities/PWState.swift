//
//  PWState.swift
//  LightOn
//
//  Created by 신정욱 on 6/3/25.
//

struct PWState {
    
    // MARK: Properties

    let text: String
    let confirmText: String
    let isFormatChecked: Bool
    
    // MARK: Initializer
    
    init(
        text: String          = "",
        confirmText: String   = "",
        isFormatChecked: Bool = false
    ) {
        self.text            = text
        self.confirmText     = confirmText
        self.isFormatChecked = isFormatChecked
    }
    
    // MARK: Update
    
    func updated(
        text: String?          = nil,
        confirmText: String?   = nil,
        isFormatChecked: Bool? = nil
    ) -> Self {
        PWState(
            text:            text            ?? self.text,
            confirmText:     confirmText     ?? self.confirmText,
            isFormatChecked: isFormatChecked ?? self.isFormatChecked
        )
    }
}

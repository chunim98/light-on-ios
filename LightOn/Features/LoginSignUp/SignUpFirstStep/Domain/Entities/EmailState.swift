//
//  EmailState.swift
//  LightOn
//
//  Created by 신정욱 on 6/2/25.
//

struct EmailState {
    
    // MARK: Properties
    
    let text: String
    let isFormatChecked: Bool
    let duplicationState: DuplicationState
    
    // MARK: Initializer
    
    init(
        text: String                       = "",
        isFormatChecked: Bool              = false,
        duplicationState: DuplicationState = .unchecked
    ) {
        self.text             = text
        self.isFormatChecked  = isFormatChecked
        self.duplicationState = duplicationState
    }
    
    // MARK: Update
    
    func updated(
        text: String?                       = nil,
        isFormatChecked: Bool?              = nil,
        duplicationState: DuplicationState? = nil
    ) -> Self {
        EmailState(
            text:             text             ?? self.text,
            isFormatChecked:  isFormatChecked  ?? self.isFormatChecked,
            duplicationState: duplicationState ?? self.duplicationState
        )
    }
}

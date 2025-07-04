//
//  TermsSectionState.swift
//  LightOn
//
//  Created by 신정욱 on 7/1/25.
//


struct TermsSectionState {
    let serviceAgreed: Bool
    let privacyAgreed: Bool
    let isOver14: Bool
    
    func updated(
        serviceAgreed: Bool? = nil,
        privacyAgreed: Bool? = nil,
        isOver14: Bool? = nil
    ) -> TermsSectionState {
        TermsSectionState(
            serviceAgreed: serviceAgreed ?? self.serviceAgreed,
            privacyAgreed: privacyAgreed ?? self.privacyAgreed,
            isOver14: isOver14 ?? self.isOver14
        )
    }
}

//
//  PWVerificationUC.swift
//  LightOn
//
//  Created by 신정욱 on 6/3/25.
//

import Combine

final class PWVerificationUC {
    
    /// 비밀번호 형식 검사
    func checkFormat(
        _ rootPWState: AnyPublisher<PWState, Never>
    ) -> AnyPublisher<PWState, Never> {
        
        rootPWState.map {
            let regex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=]).{8,}$/
            let isFormatChecked = $0.text.wholeMatch(of: regex) != nil
            return $0.updated(isFormatChecked: isFormatChecked)
        }
        .eraseToAnyPublisher()
    }
}

//
//  GetValidPhoneNumberUC.swift
//  LightOn
//
//  Created by 신정욱 on 6/30/25.
//

import Combine

final class GetValidPhoneNumberUC {
    /// 최종 인증된 폰번호 방출
    func execute(
        state: AnyPublisher<PhoneNumberFormState, Never>
    ) -> AnyPublisher<String?, Never>{
        state.map {
            $0.isVerified ? $0.phoneNumber : nil
        }
        .removeDuplicates()
        .eraseToAnyPublisher()
    }
}

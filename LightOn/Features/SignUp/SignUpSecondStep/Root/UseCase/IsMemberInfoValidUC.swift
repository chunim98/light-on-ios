//
//  IsMemberInfoValidUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/3/25.
//

import Combine

final class IsMemberInfoValidUC {
    /// 멤버 정보가 유효한지 체크
    func execute(
        memberInfo: AnyPublisher<MemberInfo, Never>
    ) -> AnyPublisher<Bool, Never> {
        memberInfo.map {
            $0.name != nil &&
            $0.phone != nil &&
            $0.regionCode != nil &&
            $0.termsAgreed
        }
        .eraseToAnyPublisher()
    }
}

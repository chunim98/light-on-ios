//
//  UpdateMemberInfoUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/3/25.
//

import Combine

final class UpdateMemberInfoUC {
    /// 멤버 정보 상태 업데이트
    func execute(
        name: AnyPublisher<String?, Never>,
        phone: AnyPublisher<String?, Never>,
        regionCode: AnyPublisher<Int?, Never>,
        termsAgreed: AnyPublisher<Bool, Never>,
        smsAgreed: AnyPublisher<Bool, Never>,
        pushAgreed: AnyPublisher<Bool, Never>,
        emailAgreed: AnyPublisher<Bool, Never>,
        memberInfo: AnyPublisher<MemberInfo, Never>
    ) -> AnyPublisher<MemberInfo, Never> {
        Publishers.Merge7(
            name.withLatestFrom(memberInfo) { $1.updated(name: .some($0)) },
            phone.withLatestFrom(memberInfo) { $1.updated(phone: .some($0)) },
            regionCode.withLatestFrom(memberInfo) { $1.updated(regionCode: .some($0)) },
            termsAgreed.withLatestFrom(memberInfo) { $1.updated(termsAgreed: $0) },
            smsAgreed.withLatestFrom(memberInfo) { $1.updated(smsAgreed: $0) },
            pushAgreed.withLatestFrom(memberInfo) { $1.updated(pushAgreed: $0) },
            emailAgreed.withLatestFrom(memberInfo) { $1.updated(emailAgreed: $0) }
        )
        .eraseToAnyPublisher()
    }
}

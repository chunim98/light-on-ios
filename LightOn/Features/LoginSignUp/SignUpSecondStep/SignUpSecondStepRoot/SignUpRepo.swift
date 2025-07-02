//
//  SignUpRepo.swift
//  LightOn
//
//  Created by 신정욱 on 7/3/25.
//

import Combine

protocol SignUpRepo {
    /// 정식 회원가입 요청 (멤버 정보 전송)
    func postMemberInfo(memberInfo: MemberInfo) -> AnyPublisher<UserToken, Never>
}

// MARK: - Default

final class DefaultSignUpRepo: SignUpRepo {
    func postMemberInfo(memberInfo: MemberInfo) -> AnyPublisher<UserToken, Never> {
        Future { promise in
            
            APIClient.shared.requestPost(
                endPoint: "/api/members/\(memberInfo.tempMemberID)/info",
                parameters: MemberInfoRequestDTO(from: memberInfo),
                decodeType: TokenResponseDTO.self
            ) {
                print("정식 회원가입 요청 완료")
                promise(.success($0.toDomain()))
            }
            
        }
        .eraseToAnyPublisher()
    }
}

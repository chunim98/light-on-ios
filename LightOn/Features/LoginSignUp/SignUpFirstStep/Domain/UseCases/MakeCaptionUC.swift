//
//  MakeCaptionUC.swift
//  LightOn
//
//  Created by 신정욱 on 5/31/25.
//

import Foundation
import Combine

final class MakeCaptionUC {
    
    // MARK: Typealias
    
    typealias CaptionConfig = SignUpTextForm.CaptionConfiguration

    // MARK: Event Handling
    
    /// 이메일 입력란 캡션 구성
    func makeEmailCaption(
        _ emailState: AnyPublisher<EmailState, Never>
    ) -> AnyPublisher<CaptionConfig?, Never> {
        
        emailState.map { switch $0 {
        case let state where state.text.isEmpty:
            return nil
            
        case let state where
            (state.duplicationState == .unchecked) &&
            !state.isFormatChecked:
            return .init(text: "올바른 메일주소를 입력하세요", isValid: false)
            
        case let state where
            (state.duplicationState == .unchecked) &&
            state.isFormatChecked:
            return nil // 이메일 형식이 맞으면 캡션을 숨김
            
        case let state where state.duplicationState == .duplicated:
            return .init(text: "중복된 이메일 주소입니다.", isValid: false)
            
        case let state where state.duplicationState == .verified:
            return .init(text: "사용 가능한 이메일 주소입니다.", isValid: true)
            
        default:
            return nil
        } }
        .eraseToAnyPublisher()
    }

    /// 비밀번호 입력란 캡션 구성
    func makePWCaption(
        _ pwState: AnyPublisher<PWState, Never>
    ) -> AnyPublisher<CaptionConfig?, Never> {
        
        pwState.map { switch $0 {
        case let state where state.text.isEmpty:
            return nil
            
        case let state where !state.isFormatChecked:
            return .init(text: "비밀번호는 영문, 숫자, 특수문자 모두 포함된 8자 이상이어야 합니다.", isValid: false)
            
        case let state where state.isFormatChecked:
            return .init(text: "사용 가능한 비밀번호 입니다.", isValid: true)
            
        default:
            return nil
        } }
        .eraseToAnyPublisher()
    }
    
    /// 비밀번호 확인란 캡션 구성
    func makeConfirmCaption(
        _ pwState: AnyPublisher<PWState, Never>
    ) -> AnyPublisher<CaptionConfig?, Never> {
        
        pwState.map { switch $0 {
        case let state where state.confirmText.isEmpty:
            return nil
            
        case let state where !state.isFormatChecked:
            return .init(text: "비밀번호는 영문, 숫자, 특수문자 모두 포함된 8자 이상이어야 합니다.", isValid: false)
            
        case let state where state.confirmText != state.text:
            return .init(text: "비밀번호가 일치하지 않습니다.", isValid: false)
            
        case let state where state.confirmText == state.text:
            return .init(text: "비밀번호가 일치합니다.", isValid: true)
            
        default:
            return nil
        } }
        .eraseToAnyPublisher()
    }
}

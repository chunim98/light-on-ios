//
//  SignUpDI.swift
//  LightOn
//
//  Created by 신정욱 on 7/4/25.
//

final class SignUpDI {
    
    // MARK: Singleton
    
    static let shared = SignUpDI()
    private init() {}
    
    // MARK: Methods
    
    func makeSignUpFirstStepVM() -> SignUpFirstStepVM {
        SignUpFirstStepVM(presignUpRepo: DefaultPresignUpRepo())
    }
    
    func makeEmailValidationFormVM() -> EmailValidationFormVM {
        EmailValidationFormVM(repo: DefaultCheckEmailDuplicationRepo())
    }
    
    func makePhoneNumberFormVM() -> PhoneNumberFormVM {
        PhoneNumberFormVM(authCodeRepo: DefaultAuthCodeRepo())
    }
    
    func makeSignUpSecondStepVM(tempUserID: Int) -> SignUpSecondStepVM {
        SignUpSecondStepVM(
            tempUserID: tempUserID,
            signUpRepo: DefaultSignUpRepo()
        )
    }
    
    func makeSelectLikingVM() -> SelectLikingVM {
        SelectLikingVM(likingGenreRepo: DefaultLikingGenreRepo())
    }
}

//
//  RegisterPerformanceDI.swift
//  LightOn
//
//  Created by 신정욱 on 7/25/25.
//

final class RegisterPerformanceDI {
    
    // MARK: Singleton
    
    static let shared = RegisterPerformanceDI()
    private init() {}
    
    // MARK: Methods
    
    func makeRegisterBuskingVM() -> RegisterBuskingVM {
        RegisterBuskingVM(repo: DefaultRegisterBuskingRepo())
    }
    
    func makeEditBuskingVM(id performanceID: Int) -> EditBuskingVM {
        EditBuskingVM(
            performanceID: performanceID,
            editBuskingRepo: DefaultEditBuskingRepo(),
            deleteBuskingRepo: DefaultDeleteBuskingRepo()
        )
    }
}

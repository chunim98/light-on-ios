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
        RegisterBuskingVM(
            registerBuskingRepo: DefaultRegisterBuskingRepo(),
            artistInfoRepo: DefaultArtistInfoRepo()
        )
    }
    
    func makeModifyBuskingVM(id performanceID: Int) -> ModifyBuskingVM {
        ModifyBuskingVM(
            performanceID: performanceID,
            editBuskingRepo: DefaultEditBuskingRepo(),
            deleteBuskingRepo: DefaultDeleteBuskingRepo()
        )
    }
    
    func makeRegisterConcertVM() -> RegisterConcertVM {
        RegisterConcertVM(
            artistInfoRepo: DefaultArtistInfoRepo(),
            registerConcertRepo: DefaultRegisterConcertRepo()
        )
    }
    
    func makeModifyConcertVM(id performanceID: Int) -> ModifyConcertVM {
        ModifyConcertVM(
            performanceID: performanceID,
            modifyConcertRepo: DefaultModifyConcertRepo()
        )
    }
}

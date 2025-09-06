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
    
    func makeRegisterConcertVM() -> RegisterConcertVM {
        RegisterConcertVM(
            artistInfoRepo: DefaultArtistInfoRepo(),
            registerConcertRepo: DefaultRegisterConcertRepo()
        )
    }
    
    func makeEditConcertVM(id performanceID: Int) -> EditConcertVM {
        EditConcertVM(
            performanceID: performanceID,
            modifyConcertRepo: DefaultModifyConcertRepo()
        )
    }
}

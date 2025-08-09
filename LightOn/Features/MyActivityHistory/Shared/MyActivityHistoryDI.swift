//
//  MyActivityHistoryDI.swift
//  LightOn
//
//  Created by 신정욱 on 8/7/25.
//

final class MyActivityHistoryDI {
    
    // MARK: Singleton
    
    static let shared = MyActivityHistoryDI()
    private init() {}
    
    // MARK: Methods
    
    func makeMyPreferredVM() -> MyPreferredVM {
        MyPreferredVM(
            preferredGenreRepo: DefaultPreferredGenreRepo(),
            preferredArtistsRepo: DefaultPreferredArtistsRepo()
        )
    }
    
    func makeMyStatsVM() -> MyStatsVM {
        MyStatsVM(repo: DefaultMyStatsInfoRepo())
    }
    
    func makeMyApplicationRequestedVM() -> MyApplicationRequestedVM {
        MyApplicationRequestedVM(repo: MyApplicationsRepo())
    }
    
    func makeMyRegistrationRequestedVM() -> MyRegistrationRequestedVM {
        MyRegistrationRequestedVM(repo: MyRegistrationsRepo())
    }
    
    func makeMyApplicationRequestedFullVM() -> MyApplicationRequestedFullVM {
        MyApplicationRequestedFullVM(repo: MyApplicationsRepo())
    }
    
    func makeMyRegistrationRequestedFullVM() -> MyRegistrationRequestedFullVM {
        MyRegistrationRequestedFullVM(repo: MyRegistrationsRepo())
    }
}

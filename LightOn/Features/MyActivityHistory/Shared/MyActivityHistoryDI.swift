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
}

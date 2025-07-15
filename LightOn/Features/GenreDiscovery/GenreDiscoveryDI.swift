//
//  GenreDiscoveryDI.swift
//  LightOn
//
//  Created by 신정욱 on 7/15/25.
//

final class GenreDiscoveryDI {
    
    // MARK: Singleton
    
    static let shared = GenreDiscoveryDI()
    private init() {}
    
    // MARK: Methods
    
    func makePopularListVM() -> PopularListVM {
        PopularListVM(repo: DefaultGenreDiscoveryRepo())
    }
}

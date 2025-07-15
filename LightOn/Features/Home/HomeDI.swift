//
//  HomeDI.swift
//  LightOn
//
//  Created by 신정욱 on 7/15/25.
//

final class HomeDI {
    
    // MARK: Singleton
    
    static let shared = HomeDI()
    private init() {}
    
    // MARK: Methods
    
    func makeHomeVM() -> HomeVM {
        HomeVM(repo: DefaultPerformanceRepo())
    }
}

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
    
    func makeBannerPageVM() -> BannerPageVM {
        BannerPageVM(repo: DefaultPerformanceBannerRepo())
    }
    
    func makeHomeRecentRecommendedVM() -> HomeRecentRecommendedVM {
        HomeRecentRecommendedVM(repo: DefaultPerformanceRepo())
    }
    
    func makeHomeSpotlightedVM() -> HomeSpotlightedVM {
        HomeSpotlightedVM(repo: DefaultPerformanceRepo())
    }
    
    func makeHomePopularVM() -> HomePopularVM {
        HomePopularVM(repo: DefaultPerformanceRepo())
    }
}

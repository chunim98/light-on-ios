//
//  PerformanceMapDI.swift
//  LightOn
//
//  Created by 신정욱 on 7/21/25.
//

final class PerformanceMapDI {
    
    // MARK: Singleton
    
    static let shared = PerformanceMapDI()
    private init() {}
    
    // MARK: Methods
    
    func makeMapListModalVM() -> MapListModalVM {
        MapListModalVM(repo: DefaultReverseGeocodingRepo())
    }
    
    func makePerformanceMapVM() -> PerformanceMapVM {
        PerformanceMapVM(repo: DefaultGeoPerformanceRepo())
    }
}

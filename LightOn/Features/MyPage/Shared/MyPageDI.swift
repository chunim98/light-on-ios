//
//  MyPageDI.swift
//  LightOn
//
//  Created by 신정욱 on 8/10/25.
//

final class MyPageDI {
    
    // MARK: Singleton
    
    static let shared = MyPageDI()
    private init() {}
    
    // MARK: Methods
    
    func makeLoginInfoVM() -> LoginInfoVM {
        LoginInfoVM(repo: DefaultMyInfoRepo())
    }
}

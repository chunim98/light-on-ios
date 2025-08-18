//
//  MyPageState.swift
//  LightOn
//
//  Created by 신정욱 on 7/4/25.
//

struct MyPageState {
    let joinArtistButtonHidden: Bool
    let logoutButtonHidden: Bool
    let deleteAccountButtonHidden: Bool
    let dividersHidden: [Bool]
    
    static var logout: MyPageState {
        MyPageState(
            joinArtistButtonHidden: true,
            logoutButtonHidden: true,
            deleteAccountButtonHidden: true,
            dividersHidden: [true, false, true]
        )
    }
    
    static var login: MyPageState {
        MyPageState(
            joinArtistButtonHidden: false,
            logoutButtonHidden: false,
            deleteAccountButtonHidden: false,
            dividersHidden: [false, false, false]
        )
    }
}

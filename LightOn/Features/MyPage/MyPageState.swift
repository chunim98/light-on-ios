//
//  MyPageState.swift
//  LightOn
//
//  Created by 신정욱 on 7/4/25.
//

struct MyPageState {
    let loggedInInfoViewHidden: Bool
    let loggedOutInfoViewHidden: Bool
    let joinArtistButtonHidden: Bool
    let logoutButtonHidden: Bool
    let deleteAccountButtonHidden: Bool
    let dividersHidden: [Bool]
    
    static var logout: MyPageState {
        MyPageState(
            loggedInInfoViewHidden: true,
            loggedOutInfoViewHidden: false,
            joinArtistButtonHidden: true,
            logoutButtonHidden: true,
            deleteAccountButtonHidden: true,
            dividersHidden: [true, false, true]
        )
    }
    
    static var login: MyPageState {
        MyPageState(
            loggedInInfoViewHidden: false,
            loggedOutInfoViewHidden: true,
            joinArtistButtonHidden: false,
            logoutButtonHidden: false,
            deleteAccountButtonHidden: false,
            dividersHidden: [false, false, false]
        )
    }
}

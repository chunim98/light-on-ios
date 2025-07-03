//
//  MyPageStyle.swift
//  LightOn
//
//  Created by 신정욱 on 7/4/25.
//

struct MyPageStyle {
    let loggedInInfoViewHidden: Bool
    let loggedOutInfoViewHidden: Bool
    let joinArtistButtonHidden: Bool
    let logoutButtonHidden: Bool
    let deleteAccountButtonHidden: Bool
    let dividersHidden: [Bool]
    
    static var logOut: MyPageStyle {
        MyPageStyle(
            loggedInInfoViewHidden: true,
            loggedOutInfoViewHidden: false,
            joinArtistButtonHidden: true,
            logoutButtonHidden: true,
            deleteAccountButtonHidden: true,
            dividersHidden: [true, false, true]
        )
    }
    
    static var logIn: MyPageStyle {
        MyPageStyle(
            loggedInInfoViewHidden: false,
            loggedOutInfoViewHidden: true,
            joinArtistButtonHidden: false,
            logoutButtonHidden: false,
            deleteAccountButtonHidden: false,
            dividersHidden: [false, false, false]
        )
    }
}

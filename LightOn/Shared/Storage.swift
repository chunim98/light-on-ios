//
//  Storage.swift
//  LightOn
//
//  Created by 신정욱 on 6/28/25.
//

import Foundation

@propertyWrapper
struct Storage<T: Equatable> {
    private let key: String
    
    var wrappedValue: T {
        // 초기화 때 기본 값 할당하므로, 강제로 언래핑해도 안전
        get { (UserDefaults.standard.object(forKey: key) as? T)! }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
    
    init(
        _ key: String,
        _ defaultValue: T
    ) {
        self.key = key
        // 기본 값 지정, 키 값이 이미 있는 경우에는 무시됨
        UserDefaults.standard.register(defaults: [key : defaultValue])
    }
}

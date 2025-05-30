//
//  OnlyOnce.swift
//  LightOn
//
//  Created by 신정욱 on 5/30/25.
//


import UIKit

/// 뷰를 구성하는 등의  단 한 번만 실행할 작업이 있을 때 사용하는 클래스
final class OnlyOnce {
    private var isExecuted = false
    
    func execute(_ execute: () -> Void) {
        guard !isExecuted else { return }
        isExecuted.toggle()
        execute()
    }
}

//
//  Coordinator.swift
//  TennisPark
//
//  Created by 신정욱 on 5/19/25.
//

import UIKit

protocol Coordinator: AnyObject {
    /// 절대 `weak`으로 선언해 줄 것
    /// 이미 부모가 배열에 넣어 강하게 참조 중!
    var parent: Coordinator? { get set }
    /// 자식을 배열에 넣어서 강한 참조를 유지
    var children: [Coordinator] { get set }
    var navigation : UINavigationController { get }
    
    func start()
}

extension Coordinator {
    
    /// 자식 코디네이터를 제거
    func free(child : Coordinator) {
        children.removeAll { $0 === child }
    }
    
    /// 자식 코디네이터를 추가
    func store(child: Coordinator) {
        child.parent = self
        children.append(child)
    }
}

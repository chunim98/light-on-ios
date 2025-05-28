//
//  Coordinator.swift
//  TennisPark
//
//  Created by 신정욱 on 5/19/25.
//

import UIKit

protocol Coordinator: AnyObject {
    /// weak으로 선언해 줄 것 (이미 부모가 배열에 넣어 강하게 참조 중이기 때문)
    var parent: Coordinator? { get set }
    /// 자식을 배열에 넣어서 강한 참조를 유지
    var childrens: [Coordinator] { get set }
    var navigationController : UINavigationController { get }
    
    func start()
}

extension Coordinator {
    /// 자식 코디네이터를 제거 (창을 닫을 때, 꼭 호출해야 함)
    func childDidFinish(_ coordinator : Coordinator) {
        childrens.removeAll { $0 === coordinator }
    }
    
    func finish() { parent?.childDidFinish(self) }
}

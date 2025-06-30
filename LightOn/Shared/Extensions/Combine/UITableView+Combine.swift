//
//  UITableView+Combine.swift
//  LightOn
//
//  Created by 신정욱 on 6/30/25.
//

import UIKit
import Combine

extension UITableView {
    
    /// 선택한 아이템의 인덱스 패스 퍼블리셔
    func selectedIndexPublisher() -> AnyPublisher<IndexPath, Never> {
        SelectedIndexPathPublisher(tableView: self)
            .share() // 멀티캐스트 처리
            .eraseToAnyPublisher()
    }
    
    /// 선택한 아이템의 모델 퍼블리셔
    func selectedModelPublisher<Section, Item>(
        dataSource: UITableViewDiffableDataSource<Section, Item>?
    ) -> AnyPublisher<Item, Never> where Item: Hashable {
        self.selectedIndexPublisher()
            .compactMap { [weak dataSource] in dataSource?.itemIdentifier(for: $0) }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Subscription
    
    final class SelectedIndexPathSubscription<S>:
        NSObject,
        Subscription,
        UITableViewDelegate
    where
        S: Subscriber,
        S.Input == IndexPath,
        S.Failure == Never
    {
        
        // MARK: Properties
        
        private var subscriber: S?
        private weak var tableView: UITableView?
        
        // MARK: Initializer
        
        init(
            subscriber: S,
            tableView: UITableView?
        ) {
            self.subscriber = subscriber
            self.tableView = tableView
            super.init()
            tableView?.delegate = self
        }
        
        // MARK: Methods
        
        func tableView(
            _ tableView: UITableView,
            didSelectRowAt indexPath: IndexPath
        ) {
            _ = subscriber?.receive(indexPath)
        }
        
        /// 사용 안 함, tableView(_:didSelectRowAt:)에 이벤트 전달 로직을 위임
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() { subscriber = nil }
    }
    
    // MARK: - Publisher
    
    struct SelectedIndexPathPublisher: Publisher {
        
        // MARK: Typealias
        
        typealias Output = IndexPath
        typealias Failure = Never
        
        // MARK: Properties
        
        private weak var tableView: UITableView?
        
        // MARK: Initializer
        
        init(tableView: UITableView?) {
            self.tableView = tableView
        }
        
        // MARK: Methods
        
        func receive<S>(subscriber: S)
        where S: Subscriber, Never == S.Failure, IndexPath == S.Input {
            let subscription = SelectedIndexPathSubscription(
                subscriber: subscriber,
                tableView: tableView
            )
            subscriber.receive(subscription: subscription)
        }
    }
    
}

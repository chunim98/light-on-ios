//
//  UICollectionView+Combine.swift
//  LightOn
//
//  Created by 신정욱 on 5/12/25.
//

import UIKit
import Combine

extension UICollectionView {
    
    func selectedIndexPublisher() -> AnyPublisher<IndexPath, Never> {
        SelectedIndexPathPublisher(collectionView: self).eraseToAnyPublisher()
    }
    
    func selectedModelPublisher<Section, Item>(
        dataSource: UICollectionViewDiffableDataSource<Section, Item>
    ) -> AnyPublisher<Item, Never> where Item: Hashable {
        self.selectedIndexPublisher()
            .compactMap { [weak dataSource] in dataSource?.itemIdentifier(for: $0) }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Subscription
    
    final class SelectedIndexPathSubscription<S>:
        NSObject,
        Subscription,
        UICollectionViewDelegate
    where
        S: Subscriber,
        S.Input == IndexPath,
        S.Failure == Never
    {
        
        // MARK: Properties
        
        private var subscriber: S?
        private weak var collectionView: UICollectionView?
        
        // MARK: Initializer
        
        init(
            subscriber: S,
            collectionView: UICollectionView?
        ) {
            self.subscriber = subscriber
            self.collectionView = collectionView
            super.init()
            collectionView?.delegate = self
        }
        
        // MARK: Methods

        func collectionView(
            _ collectionView: UICollectionView,
            didSelectItemAt indexPath: IndexPath
        ) {
            _ = subscriber?.receive(indexPath)
        }
        
        // 사용 안 함 (collectionView에 이벤트 전달 로직을 위임)
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() { subscriber = nil }
    }
    
    // MARK: - Publisher
    
    struct SelectedIndexPathPublisher: Publisher {
        
        // MARK: Typealias
        
        typealias Output = IndexPath
        typealias Failure = Never
        
        // MARK: Properties
        
        private weak var collectionView: UICollectionView?
        
        // MARK: Initializer
        
        init(collectionView: UICollectionView?) {
            self.collectionView = collectionView
        }
        
        // MARK: Methods
        
        func receive<S>(subscriber: S)
        where S: Subscriber, Never == S.Failure, IndexPath == S.Input {
            let subscription = SelectedIndexPathSubscription(
                subscriber: subscriber,
                collectionView: collectionView
            )
            subscriber.receive(subscription: subscription)
        }
    }
}

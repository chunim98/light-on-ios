//
//  UIGestureRecognizer+Combine.swift
//  LightOn
//
//  Created by 신정욱 on 5/7/25.
//

import UIKit
import Combine

extension UITapGestureRecognizer {
    func publisher() -> UIGestureRecognizerPublisher<UITapGestureRecognizer> {
        UIGestureRecognizerPublisher(gesture: self)
    }
}

extension UIPinchGestureRecognizer {
    func publisher() -> UIGestureRecognizerPublisher<UIPinchGestureRecognizer> {
        UIGestureRecognizerPublisher(gesture: self)
    }
}

extension UIRotationGestureRecognizer {
    func publisher() -> UIGestureRecognizerPublisher<UIRotationGestureRecognizer> {
        UIGestureRecognizerPublisher(gesture: self)
    }
}

extension UISwipeGestureRecognizer {
    func publisher() -> UIGestureRecognizerPublisher<UISwipeGestureRecognizer> {
        UIGestureRecognizerPublisher(gesture: self)
    }
}

extension UIPanGestureRecognizer {
    func publisher() -> UIGestureRecognizerPublisher<UIPanGestureRecognizer> {
        UIGestureRecognizerPublisher(gesture: self)
    }
}

extension UIScreenEdgePanGestureRecognizer {
    func publisher() -> UIGestureRecognizerPublisher<UIScreenEdgePanGestureRecognizer> {
        UIGestureRecognizerPublisher(gesture: self)
    }
}

extension UILongPressGestureRecognizer {
    func publisher() -> UIGestureRecognizerPublisher<UILongPressGestureRecognizer> {
        UIGestureRecognizerPublisher(gesture: self)
    }
}

extension UIHoverGestureRecognizer {
    func publisher() -> UIGestureRecognizerPublisher<UIHoverGestureRecognizer> {
        UIGestureRecognizerPublisher(gesture: self)
    }
}

// MARK: - Subscription

final class UIGestureRecognizerSubscription<G, S>: Subscription
where
G: UIGestureRecognizer,
S: Subscriber,
S.Input == G,
S.Failure == Never
{
    
    // MARK: Properties
    
    private var subscriber: S?
    private let gesture: G
    
    // MARK: Initializer
    
    init(subscriber: S, gesture: G) {
        self.subscriber = subscriber
        self.gesture = gesture
        self.gesture.addTarget(self, action: #selector(handleEvent))
    }
    
    // MARK: Methods
    
    @objc private func handleEvent() { _ = subscriber?.receive(gesture) }
    
    // 사용 안 함 (handleEvent에 이벤트 전달 로직을 위임)
    func request(_ demand: Subscribers.Demand) {}
    
    func cancel() {
        subscriber = nil
        gesture.removeTarget(self, action: #selector(handleEvent))
    }
}

// MARK: - Publisher

struct UIGestureRecognizerPublisher<G: UIGestureRecognizer>: Publisher {
    
    // MARK: Typealias
    
    typealias Output = G
    typealias Failure = Never
    
    // MARK: Properties
    
    private let gesture: G
    
    // MARK: Initializer
    
    init(gesture: G) {
        self.gesture = gesture
    }
    
    // MARK: Methods
    
    func receive<S>(subscriber: S)
    where
    S: Subscriber,
    S.Input == G,
    S.Failure == Never
    {
        let subscription = UIGestureRecognizerSubscription(
            subscriber: subscriber,
            gesture: gesture
        )
        subscriber.receive(subscription: subscription)
    }
}

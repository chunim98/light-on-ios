//
//  CombineVC.swift
//  LightOn
//
//  Created by 신정욱 on 7/24/25.
//

import UIKit
import Combine

class CombineVC: UIViewController {
    
    // MARK: Subjects
    
    private let viewDidLoadSubject              = PassthroughSubject<Void, Never>()
    private let viewWillAppearSubject           = PassthroughSubject<Void, Never>()
    private let viewWillLayoutSubviewsSubject   = PassthroughSubject<Void, Never>()
    private let viewDidLayoutSubviewsSubject    = PassthroughSubject<Void, Never>()
    private let viewDidAppearSubject            = PassthroughSubject<Void, Never>()
    private let viewWillDisappearSubject        = PassthroughSubject<Void, Never>()
    private let viewDidDisappearSubject         = PassthroughSubject<Void, Never>()
    private let deallocatedSubject              = PassthroughSubject<Void, Never>()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadSubject.send(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearSubject.send(())
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewWillLayoutSubviewsSubject.send(())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewDidLayoutSubviewsSubject.send(())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppearSubject.send(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewWillDisappearSubject.send(())
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewDidDisappearSubject.send(())
    }
    
    deinit { deallocatedSubject.send(()) }
}

extension CombineVC {
    /// viewDidLoad 이벤트 퍼블리셔
    var viewDidLoadPublisher: AnyPublisher<Void, Never> {
        viewDidLoadSubject.eraseToAnyPublisher()
    }
    
    /// viewWillAppear 이벤트 퍼블리셔
    var viewWillAppearPublisher: AnyPublisher<Void, Never> {
        viewWillAppearSubject.eraseToAnyPublisher()
    }
    
    /// viewWillLayoutSubviews 이벤트 퍼블리셔
    var viewWillLayoutSubviewsPublisher: AnyPublisher<Void, Never> {
        viewWillLayoutSubviewsSubject.eraseToAnyPublisher()
    }
    
    /// viewDidLayoutSubviews 이벤트 퍼블리셔
    var viewDidLayoutSubviewsPublisher: AnyPublisher<Void, Never> {
        viewDidLayoutSubviewsSubject.eraseToAnyPublisher()
    }
    
    /// viewDidAppear 이벤트 퍼블리셔
    var viewDidAppearPublisher: AnyPublisher<Void, Never> {
        viewDidAppearSubject.eraseToAnyPublisher()
    }
    
    /// viewWillDisappear 이벤트 퍼블리셔
    var viewWillDisappearPublisher: AnyPublisher<Void, Never> {
        viewWillDisappearSubject.eraseToAnyPublisher()
    }
    
    /// viewDidDisappear 이벤트 퍼블리셔
    var viewDidDisappearPublisher: AnyPublisher<Void, Never> {
        viewDidDisappearSubject.eraseToAnyPublisher()
    }
    
    /// deinit 이벤트 퍼블리셔
    var deallocatedPublisher: AnyPublisher<Void, Never> {
        deallocatedSubject.eraseToAnyPublisher()
    }
}

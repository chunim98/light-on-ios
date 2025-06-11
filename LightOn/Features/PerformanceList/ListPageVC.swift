//
//  ListPageVC.swift
//  LightOn
//
//  Created by 신정욱 on 6/11/25.
//


import UIKit
import Combine

import SnapKit

final class ListPageVC: UIPageViewController {
    
    // MARK: Properties

    private var cancellables = Set<AnyCancellable>()
    
    private var pages = [UIViewController]()
    private var currentIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
        return pages.firstIndex(of: vc) ?? 0
    }
    
    // MARK: Outputs
    
    private let pageIndexSubject = PassthroughSubject<Int, Never>()
    
    // MARK: Life Cycle
    
    init() { super.init(transitionStyle: .scroll, navigationOrientation: .horizontal) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        pages = [
            {
                let vc = UIViewController()
                vc.view.backgroundColor = .gray
                return vc
            }(),
            {
                let vc = UIViewController()
                vc.view.backgroundColor = .darkGray
                return vc
            }()
        ]
        setViewControllers([pages[0]], direction: .forward, animated: true)
        
        dataSource = self
        delegate = self
    }
}

// MARK: Binders & Publishers

extension ListPageVC {
    func pageIndexBidner(index: Int) {
        // 이전 페이지 인덱스에 따라, 전환 애니메이션 방향을 다르게 설정
        let direction: UIPageViewController.NavigationDirection
        direction = currentIndex < index ? .forward : .reverse
        
        setViewControllers([pages[index]], direction: direction, animated: true)
    }
    
    var pageIndexPublisher: AnyPublisher<Int, Never> {
        pageIndexSubject.eraseToAnyPublisher()
    }
}

// MARK: - UIPageViewControllerDelegate

extension ListPageVC: UIPageViewControllerDelegate {
    /// 사용자가 스와이프해서 페이지를 변경할 때만 실행됨
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if completed { pageIndexSubject.send(currentIndex) }
    }
}

// MARK: - UIPageViewControllerDataSource

extension ListPageVC: UIPageViewControllerDataSource {
    /// 좌우 스와이프 할 때 어떤 페이지를 보여줄지에 관한 메서드
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard
            let currentIndex = pages.firstIndex(of: viewController),
            currentIndex > 0
        else { return nil }
        
        return pages[currentIndex-1]
    }
    
    /// 좌우 스와이프 할 때 어떤 페이지를 보여줄지에 관한 메서드
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard
            let currentIndex = pages.firstIndex(of: viewController),
            currentIndex < (pages.count-1)
        else { return nil }
        
        return pages[currentIndex+1]
    }
}

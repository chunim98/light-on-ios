//
//  BannerPageVC.swift
//  LightOn
//
//  Created by 신정욱 on 5/13/25.
//

import UIKit
import Combine

import SnapKit

final class BannerPageVC: UIPageViewController {
    
    // MARK: Properties

    private var cancellables = Set<AnyCancellable>()
    
    private var pages = [UIViewController]()
    private var currentIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
        return pages.firstIndex(of: vc) ?? 0
    }
    
    // MARK: Components
    
    private let pageControl = PageControl()

    // MARK: Life Cycle
    
    init() { super.init(transitionStyle: .scroll, navigationOrientation: .horizontal) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        pages = TestBannerItem.mockItems.map { BannerVC(item: $0) } // temp
        setViewControllers([pages[0]], direction: .forward, animated: true)
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        dataSource = self
        delegate = self
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(18)
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        pageControl.pageIndexPublisher
            .sink { [weak self] in self?.pageIndexBidner(index: $0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension BannerPageVC {
    private func pageIndexBidner(index: Int) {
        // 이전 페이지 인덱스에 따라, 전환 애니메이션 방향을 다르게 설정
        let direction: UIPageViewController.NavigationDirection =
        currentIndex < index ? .forward : .reverse
        
        setViewControllers([pages[index]], direction: direction, animated: true)
    }
}

// MARK: - UIPageViewControllerDelegate

extension BannerPageVC: UIPageViewControllerDelegate {
    /// 사용자가 스와이프해서 페이지를 변경할 때만 실행됨
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if completed { pageControl.currentPage = currentIndex }
    }
}

// MARK: - UIPageViewControllerDataSource

extension BannerPageVC: UIPageViewControllerDataSource {
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

// MARK: - Preview

#Preview(traits: .fixedLayout(width: 402, height: 402)) { BannerPageVC() }

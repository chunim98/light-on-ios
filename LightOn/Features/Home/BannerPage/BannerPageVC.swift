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
    private var vm = HomeDI.shared.makeBannerPageVM()
    
    private var pages = [UIViewController]()
    private var currentIndex: Int? { viewControllers?.first.flatMap { pages.firstIndex(of: $0) } }
    
    // MARK: Subjects
    
    /// 선택한 페이지의 공연 ID를 외부로 방출하는 서브젝트
    ///
    /// `pages` 초기화가 지연될 수 있으므로, 초기 구독 시점부터 스트림을 미리 열어둠
    private let selectedIDSubject = PassthroughSubject<Int, Never>()
    
    // MARK: Components
    
    private let pageControl = BannerPageControl()
    
    // MARK: Life Cycle
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        dataSource = self
        delegate = self
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(pageControl)
        
        view.snp.makeConstraints {
            $0.size.equalTo(view.snp.width)
        }
        pageControl.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(18)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let input = BannerPageVM.Input()
        let output = vm.transform(input)
        
        output.performances
            .sink { [weak self] in self?.bindBannerItems($0) }
            .store(in: &cancellables)
        
        // 페이지 인디케이터 변경 시, 해당 페이지로 이동
        pageControl.pageIndexPublisher
            .sink { [weak self] in self?.bindPageIndex($0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension BannerPageVC {
    /// 베너 데이터 바인딩
    func bindBannerItems(_ items: [PerformanceBannerItem]) {
        guard !items.isEmpty else { return }
        // 배너 생성 및 초기화
        pages = items.map { BannerVC(item: $0) }
        setViewControllers([pages[0]], direction: .forward, animated: true)
        // 페이지 컨트롤 초기화
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.setNeedsDisplay() // 반투명 배경 강제 렌더링
        // 배너 퍼블리셔 바인딩
        Publishers
            .MergeMany(pages.map { ($0 as! BannerVC).tapWithIDPublsisher })
            .sink { [weak self] in self?.selectedIDSubject.send($0) }
            .store(in: &cancellables)
    }
    
    /// 페이지 컨트롤의 인덱스 바인딩
    private func bindPageIndex(_ index: Int) {
        guard let currentIndex else { return }
        // 이전 페이지 인덱스에 따라, 전환 애니메이션 방향을 다르게 설정
        let direction: UIPageViewController.NavigationDirection
        direction = currentIndex < index ? .forward : .reverse
        setViewControllers([pages[index]], direction: direction, animated: true)
    }
    
    /// 선택한 공연 ID 퍼블리셔
    var selectedIDPublisher: AnyPublisher<Int, Never> {
        selectedIDSubject.eraseToAnyPublisher()
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
        guard let currentIndex, completed else { return }
        pageControl.currentPage = currentIndex
    }
}

// MARK: - UIPageViewControllerDataSource

extension BannerPageVC: UIPageViewControllerDataSource {
    /// 좌우 스와이프 할 때 보여줄 이전 페이지 (무한 순환)
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex, pages.count > 1 else { return nil }
        
        let previousIndex = (currentIndex-1 + pages.count) % pages.count
        return pages[previousIndex]
    }
    
    /// 좌우 스와이프 할 때 보여줄 다음 페이지 (무한 순환)
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex, pages.count > 1 else { return nil }
        
        let nextIndex = (currentIndex+1) % pages.count
        return pages[nextIndex]
    }
}


// MARK: - Preview

#Preview(traits: .fixedLayout(width: 402, height: 402)) { BannerPageVC() }

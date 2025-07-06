//
//  SelectLikingVC.swift
//  LightOn
//
//  Created by 신정욱 on 5/30/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class SelectLikingVC: NavigationBarVC {
    
    // MARK: Properties
    
    private let vm = SignUpDI.shared.makeSelectLikingVM()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Outputs
    
    private let postCompletionSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical)
    private let buttonHStack = {
        let sv = UIStackView()
        sv.inset = .init(horizontal: 16)
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    private let skipButton = {
        let button = LOButton(style: .borderedTinted)
        button.setTitle("건너뛰기", .pretendard.bold(16))
        return button
    }()
    
    private let nextButton = {
        let button = LOButton(style: .filled)
        button.setTitle("다음", .pretendard.bold(16))
        return button
    }()
    
    private let titleLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.bold(22)
        config.foregroundColor = .loBlack
        config.text = "음악 취향을 알려주세요!"
        config.alignment = .center
        return LOLabel(config: config)
    }()
    
    private let descriptionLabel = {
        var config = AttrConfiguration()
        config.text = "좋아하는 음악 장르를 알려주시면\n취향에 맞는 공연을 알려드려요"
        config.font = .pretendard.regular(16)
        config.foregroundColor = .loBlack
        config.alignment = .center
        config.lineHeight = 22
        
        let label = LOLabel(config: config)
        label.numberOfLines = 2
        return label
    }()
    
    private let genreCollectionView = GenreCollectionView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        // 뒤로가기 스와이프 제스처 비활성화
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(titleLabel)
        mainVStack.addArrangedSubview(LOSpacer(7))
        mainVStack.addArrangedSubview(descriptionLabel)
        mainVStack.addArrangedSubview(LOSpacer(20))
        mainVStack.addArrangedSubview(genreCollectionView)
        mainVStack.addArrangedSubview(buttonHStack)
        
        buttonHStack.addArrangedSubview(skipButton)
        buttonHStack.addArrangedSubview(nextButton)
        
        mainVStack.snp.makeConstraints { $0.edges.equalTo(contentLayoutGuide) }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let selectedItem = genreCollectionView.selectedModelPublisher(
            dataSource: genreCollectionView.diffableDataSource
        )
        
        let input = SelectLikingVM.Input(
            selectedItem: selectedItem,
            nextButtonTap: nextButton.tapPublisher
        )
        let output = vm.transform(input)
        
        output.genreCellItems
            .sink { [weak self] in self?.genreCollectionView.setSnapshot(items: $0) }
            .store(in: &cancellables)
        
        output.nextButtonEnabled
            .sink { [weak self] in self?.nextButton.isEnabled = $0 }
            .store(in: &cancellables)
        
        output.postCompletion
            .sink { [weak self] in self?.postCompletionSubject.send($0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension SelectLikingVC {
    /// 스킵 버튼 탭 퍼블리셔
    var skipTapPublisher: AnyPublisher<Void, Never> { skipButton.tapPublisher }
    
    /// 장르 전송 완료 이벤트 퍼블리셔
    var postCompletionPublisher: AnyPublisher<Void, Never> {
        postCompletionSubject.eraseToAnyPublisher()
    }
}

// MARK: - Preview

#Preview { SelectLikingVC() }

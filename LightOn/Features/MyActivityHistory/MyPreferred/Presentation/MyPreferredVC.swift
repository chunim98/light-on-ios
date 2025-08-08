//
//  MyPreferredVC.swift
//  LightOn
//
//  Created by 신정욱 on 8/7/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

final class MyPreferredVC: CombineVC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let vm = MyActivityHistoryDI.shared.makeMyPreferredVM()
    
    // MARK: Components
    
    private let mainVStack = UIStackView(.vertical, inset: .init(vertical: 30))
    
    private let artistHeaderLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.bold(16)
        config.foregroundColor = .loBlack
        config.lineHeight = 24
        config.text = "좋아하는 아티스트"
        return LOPaddingLabel(
            configuration: config,
            padding: .init(horizontal: 18)
        )
    }()
    
    private let genreHeaderLabel = {
        var config = AttrConfiguration()
        config.font = .pretendard.bold(16)
        config.foregroundColor = .loBlack
        config.lineHeight = 24
        config.text = "나의 취향"
        return LOPaddingLabel(
            configuration: config,
            padding: .init(horizontal: 18)
        )
    }()
    
    private let artistCollectionView = MyPreferredCollectionView()
    private let genreCollectionView = MyPreferredCollectionView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {}
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(mainVStack)
        mainVStack.addArrangedSubview(artistHeaderLabel)
        mainVStack.addArrangedSubview(LOSpacer(10))
        mainVStack.addArrangedSubview(artistCollectionView)
        mainVStack.addArrangedSubview(LOSpacer(26))
        mainVStack.addArrangedSubview(genreHeaderLabel)
        mainVStack.addArrangedSubview(LOSpacer(10))
        mainVStack.addArrangedSubview(genreCollectionView)
        
        mainVStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        let loginEvent = SessionManager.shared.$loginState
            .compactMap { $0 == .login ? Void() : nil }
            .eraseToAnyPublisher()
        
        let trigger = Publishers
            .Merge(viewDidLoadPublisher, loginEvent)
            .eraseToAnyPublisher()
        
        let input = MyPreferredVM.Input(loadTrigger: trigger)
        let output = vm.transform(input)
        
        output.preferredArtists
            .sink { [weak self] in self?.artistCollectionView.setSnapshot(items: $0) }
            .store(in: &cancellables)
        
        output.preferredGenres
            .sink { [weak self] in self?.genreCollectionView.setSnapshot(items: $0) }
            .store(in: &cancellables)
    }
}

// MARK: - Preview

#Preview { MyPreferredVC() }

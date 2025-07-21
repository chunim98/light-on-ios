//
//  MapGrabberModalView.swift
//  LightOn
//
//  Created by 신정욱 on 7/18/25.
//

import UIKit
import Combine

import CombineCocoa
import SnapKit

class MapGrabberModalView: MapBaseModalView {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private var heightConstraint: Constraint?
    
    // MARK: Components
    
    private let panGesture = UIPanGestureRecognizer()
    
    let grabberHeaderVStack = {
        // 그래버
        let divider = LODivider(
            width: 30, height: 3, color: .assistive
        )
        divider.layer.cornerRadius = 1.5
        divider.clipsToBounds = true
        // 스택뷰
        let sv = UIStackView(.vertical)
        sv.alignment = .center
        // 레이아웃
        sv.addArrangedSubview(LOSpacer(12))
        sv.addArrangedSubview(divider)
        return sv
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
        setupBindings()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Defaults
    
    private func setupDefaults() { grabberHeaderVStack.addGestureRecognizer(panGesture) }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.addArrangedSubview(grabberHeaderVStack)
        contentView.addArrangedSubview(LOSpacer())
        self.snp.makeConstraints {
            heightConstraint = $0.height.equalTo(250).constraint
        }
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        panGesture.panPublisher
            .sink { [weak self] in self?.bindModalHeight($0) }
            .store(in: &cancellables)
    }
}

// MARK: Binders & Publishers

extension MapGrabberModalView {
    /// 모달 높이 갱신 바인더
    private func bindModalHeight(_ gesture: UIPanGestureRecognizer) {
        let velocityY = gesture.velocity(in: grabberHeaderVStack).y     // y축 가속도
        let changeY = gesture.translation(in: grabberHeaderVStack).y    // y축 이동한 거리
        gesture.setTranslation(.zero, in: grabberHeaderVStack)          // 0 초기화로 바뀐 값만 추출
        
        let height = (frame.height - changeY).clamped(250...500)        // 높이의 범위 제한
        heightConstraint?.update(offset: height)                        // 뷰 높이 실시간 변경
        
        guard gesture.state == .ended else { return }                   // 제스처가 끝났을 때만 아래 코드 실행
        let snapHeight: CGFloat
        
        // 초당 500픽셀 이동할 정도?
        if abs(velocityY) > 500 {
            // 속도가 빠르면 가속도 기반으로 스냅
            snapHeight = velocityY > 0 ? 250 : 500                      // 마이너스: 내리기, 플러스: 올리기
        } else {
            // 느리면 현재 높이 기준으로 스냅
            snapHeight = height < 375 ? 250 : 500
        }
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.75,                               // 스프링 효과(1.0에 가까울수록 덜 튕김)
            initialSpringVelocity: velocityY / 1000,                    // 속도에 비례한 초기 가속도
            options: [.allowUserInteraction, .beginFromCurrentState]
        ) { [weak self] in
            self?.heightConstraint?.update(offset: snapHeight)          // 최종 높이 업데이트
            self?.superview?.layoutIfNeeded()
        }
    }
}

//
//  LODatePickerCell.swift
//  LightOn
//
//  Created by 신정욱 on 5/14/25.
//

import UIKit

import FSCalendar
import SnapKit

final class LODatePickerCell: FSCalendarCell {
    
    // MARK: Properties
    
    static let id = "LODatePickerCell"
    
    private var radius: CGFloat { 35/2 }
    
    // MARK: Components
    
    private let backView = UIView()
    private let selectionView = UIView()
    
    private let dateLabel = {
        var config = AttrConfiguration()
        config.alignment = .center
        return LOLabel(config: config)
    }()
    
    // MARK: Life Cycle
    
    override init!(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.isHidden = true // 자체 타이틀 사용(dateLabel)
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // backView 초기화
        backView.backgroundColor = nil
        backView.layer.mask = nil
        
        // selectionView 초기화
        selectionView.backgroundColor = nil
        selectionView.layer.cornerRadius = 0
        selectionView.layer.borderWidth = 0
        selectionView.layer.borderColor = nil
        
        // dateLabel 초기화
        dateLabel.config.foregroundColor = nil
        dateLabel.config.font = nil
        dateLabel.config.text = nil
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        contentView.addSubview(backView)
        backView.addSubview(selectionView)
        backView.addSubview(dateLabel)
        
        backView.snp.makeConstraints {
            $0.horizontalEdges.centerY.equalToSuperview()
            $0.height.equalTo(35)
        }
        selectionView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(35)
        }
        dateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(35)
        }
    }
    
    // MARK: Left Rounded Mask
    
    /// 좌측 모서리만 둥글게 마스킹한 `CAShapeLayer`를 반환
    ///
    /// - rect: selectionView의 시작 x좌표부터 contentView 전체 너비를 커버
    private func getLeftRoundedMask() -> CAShapeLayer {
        let mask = CAShapeLayer()
        let rect = CGRect(
            x: selectionView.frame.minX,
            y: selectionView.frame.minY,
            width: contentView.frame.width,
            height: selectionView.frame.height
        )
        
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.topLeft, .bottomLeft],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        mask.path = path.cgPath
        return mask
    }
    
    // MARK: Right Rounded Mask
    
    /// 우측 모서리만 둥글게 마스킹한 `CAShapeLayer`를 반환
    ///
    /// - rect: contentView의 시작 x좌표부터 selectionView의 끝 x좌표까지 커버
    private func getRightRoundedMask() -> CAShapeLayer {
        let mask = CAShapeLayer()
        let rect = CGRect(
            x: contentView.frame.minX,
            y: contentView.frame.minY,
            width: selectionView.frame.maxX,
            height: selectionView.frame.height
        )
        
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.topRight, .bottomRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        mask.path = path.cgPath
        return mask
    }
    
    // MARK: Rounded Mask
    
    /// selectionView 전체를 둥글게 마스킹한 `CAShapeLayer`를 반환
    private func getRoundMask() -> CAShapeLayer {
        let mask = CAShapeLayer()
        let path = UIBezierPath(
            roundedRect: selectionView.frame,
            cornerRadius: radius
        )
        
        mask.path = path.cgPath
        return mask
    }
    
    // MARK: BackView Configuration
    
    
    /// 선택 상태(selection)와 요일(weekDay)에 따라 BackView의 마스크를 설정
    ///
    /// - start: 시작일이면 좌측만 둥글게, 단 주말(일요일)일 경우 전체 둥글게
    /// - end: 종료일이면 우측만 둥글게, 단 주초(월요일)일 경우 전체 둥글게
    /// - inRange: 범위 안에 있을 경우, 주말/주초에는 각각 우측/좌측만 둥글게
    private func configureBackViewMask(selection: LODatePickerCellSelection, weakDay: Int) {
        switch selection {
        case .start:
            backView.layer.mask = (weakDay == 7) ? getRoundMask() : getLeftRoundedMask()
            
        case .end:
            backView.layer.mask = (weakDay == 1) ? getRoundMask() : getRightRoundedMask()
            
        case .inRange:
            if weakDay == 7 {
                backView.layer.mask = getRightRoundedMask()
            } else if weakDay == 1 {
                backView.layer.mask = getLeftRoundedMask()
            }
            
        default:
            break
        }
    }
    
    // MARK: Public Configuration
    
    func configure(selection: LODatePickerCellSelection, date: Date) {
        let day = String(Calendar.current.component(.day, from: date))
        let weakDay = Calendar.current.component(.weekday, from: date)
        let style = LODatePickerCellStyle(selection)
        
        // backView 초기화
        backView.backgroundColor = style.backgroundColor
        configureBackViewMask(selection: selection, weakDay: weakDay)
        
        // selectionView 초기화
        selectionView.backgroundColor = style.selectionColor
        selectionView.layer.cornerRadius = style.selectionCornerRadius
        selectionView.layer.borderWidth = style.selectionBorderWidth
        selectionView.layer.borderColor = style.selectionBorderColor?.cgColor
        
        // dateLabel 초기화
        dateLabel.config.foregroundColor = style.dateColor
        dateLabel.config.font = style.dateFont
        dateLabel.config.text = day
    }
}

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
    
    // MARK: Enum
    
    enum SelectionType {
        case `default`
        case single
        case start
        case end
        case inRange
    }
    
    // MARK: Properties
    
    static let id = "LODatePickerCell"
    private var radius: CGFloat { 35/2 }
    
    // MARK: Components
    
    private let backView = UIView()
    private let selectionView = UIView()
    private let dateLabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Life Cycle
    
    override init!(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.isHidden = true // 자체 타이틀 사용(dateLabel)
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetComponents()
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
    
    private func getRoundMask() -> CAShapeLayer {
        let mask = CAShapeLayer()
        let path = UIBezierPath(
            roundedRect: selectionView.frame,
            cornerRadius: radius
        )
        
        mask.path = path.cgPath
        return mask
    }
    
    // MARK: Reset Components
    
    private func resetComponents() {
        // backView 초기화
        backView.backgroundColor = nil
        backView.layer.mask = nil

        // selectionView 초기화
        selectionView.backgroundColor = nil
        selectionView.layer.cornerRadius = 0
        selectionView.layer.borderWidth = 0
        selectionView.layer.borderColor = nil
        
        // dateLabel 초기화
        dateLabel.textColor = nil
        dateLabel.font = nil
        dateLabel.text = nil
    }

    // MARK: BackView Configuration
    
    private func configureBackView(for selection: SelectionType, weakDay: Int) {
        switch selection {
        case .start:
            backView.backgroundColor = UIColor(hex: 0xF5F0FF)
            backView.layer.mask = (weakDay == 7) ? getRoundMask() : getLeftRoundedMask()
            
        case .end:
            backView.backgroundColor = UIColor(hex: 0xF5F0FF)
            backView.layer.mask = (weakDay == 1) ? getRoundMask() : getRightRoundedMask()
            
        case .inRange:
            backView.backgroundColor = UIColor(hex: 0xF5F0FF)
            if weakDay == 7 {
                backView.layer.mask = getRightRoundedMask()
            } else if weakDay == 1 {
                backView.layer.mask = getLeftRoundedMask()
            }
            
        default:
            backView.backgroundColor = .clear
        }
    }

    // MARK: SelectionView Configuration
    
    private func configureSelectionView(for selection: SelectionType) {
        switch selection {
        case .single:
            selectionView.layer.cornerRadius = radius
            selectionView.backgroundColor = .brand
            
        case .start:
            selectionView.layer.cornerRadius = radius
            selectionView.backgroundColor = .brand
            
        case .end:
            selectionView.layer.cornerRadius = radius
            selectionView.backgroundColor = .white
            selectionView.layer.borderColor = UIColor.brand.cgColor
            selectionView.layer.borderWidth = 1
            
        default:
            selectionView.backgroundColor = .clear
        }
    }

    // MARK: DateLabel Configuration
    
    private func configureDateLabel(day: String, for selection: SelectionType) {
        dateLabel.text = day
        
        switch selection {
        case .single, .start:
            dateLabel.font = .pretendard.semiBold(18)
            dateLabel.textColor = .white
            
        case .end:
            dateLabel.font = .pretendard.semiBold(18)
            dateLabel.textColor = .brand
            
        case .inRange:
            dateLabel.font = .pretendard.regular(18)
            dateLabel.textColor = .caption
            
        default:
            dateLabel.font = .pretendard.regular(18)
            dateLabel.textColor = .caption
        }
    }
    
    // MARK: Public Configuration
    
    func configure(selection: SelectionType, date: Date) {
        let day = String(Calendar.current.component(.day, from: date))
        let weakDay = Calendar.current.component(.weekday, from: date)
        
        configureBackView(for: selection, weakDay: weakDay)
        configureSelectionView(for: selection)
        configureDateLabel(day: day, for: selection)
    }
}

// MARK: - Preview

#Preview { LODatePickerStyledBodyView() }

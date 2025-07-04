//
//  ProvinceTableViewContainer.swift
//  LightOn
//
//  Created by 신정욱 on 6/26/25.
//

import UIKit

import SnapKit

final class ProvinceTableViewContainer: UIView {

    // MARK: Components
    
    let tableView = ProvinceTableView()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // shadowPath로 그림자 렌더링 성능 개선
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        layer.shadowOffset  = .init(width: 0, height: 5)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius  = 15
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

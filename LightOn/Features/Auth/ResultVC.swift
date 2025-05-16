//
//  ResultVC.swift
//  LightOn
//
//  Created by 신정욱 on 4/28/25.
//


import UIKit

import SnapKit

final class ResultVC: UIViewController {

    // MARK: Properties
    
    private let textView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 18, weight: .bold)
        textView.isSelectable = false
        textView.isEditable = false
        return textView
    }()
    
    // MARK: Life Cycle
    
    init(resultText: String) {
        self.textView.text = resultText
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        view.addSubview(textView)
        textView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
    }
}

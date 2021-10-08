//
//  ViewController.swift
//  KeepIt-iOS
//
//  Created by ITlearning on 2021/09/26.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    private let keepItMainLabel: UILabel = {
        let label = UILabel()
        label.text = "Keep It"
        label.font = UIFont.boldSystemFont(ofSize: 45)
        label.textColor = .black
        
        return label
    }()
    
    private let currentButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "최신순"
        return button
    }()
    
    private let starButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "중요도순"
        return button
    }()
    
    private let priceButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "가격순"
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        configureUI()
    }

    private func configureUI() {
        self.title = "Keep It"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 30)
        ]
        self.navigationItem.rightBarButtonItems = [currentButton, starButton, priceButton]
    }
    
}


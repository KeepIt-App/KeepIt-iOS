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
        label.text = "KeepIt!"
        label.font = UIFont(name: "NanumSquareEB", size: 25)
        label.textColor = #colorLiteral(red: 0.1882352941, green: 0.1882352941, blue: 0.1882352941, alpha: 1)
        
        return label
    }()

    private let latestOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("최신순", for: .normal)
        button.tintColor = #colorLiteral(red: 0.6039215686, green: 0.6352941176, blue: 0.662745098, alpha: 1)
        button.titleLabel?.font = UIFont(name: "NanumSquareB", size: 13)
        return button
    }()

    private let importanceOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("중요도순", for: .normal)
        button.tintColor = #colorLiteral(red: 0.6039215686, green: 0.6352941176, blue: 0.662745098, alpha: 1)
        button.titleLabel?.font = UIFont(name: "NanumSquareB", size: 13)
        return button
    }()

    private let priceOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("가격순", for: .normal)
        button.tintColor = #colorLiteral(red: 0.6039215686, green: 0.6352941176, blue: 0.662745098, alpha: 1)
        button.titleLabel?.font = UIFont(name: "NanumSquareB", size: 13)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }

    private func configureUI() {
        navigationItem.setLeftBarButton(UIBarButtonItem.init(customView: keepItMainLabel), animated: true)
        navigationItem.setRightBarButtonItems([UIBarButtonItem.init(customView: latestOrderButton), UIBarButtonItem.init(customView: importanceOrderButton), UIBarButtonItem.init(customView: priceOrderButton)], animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
    }
}


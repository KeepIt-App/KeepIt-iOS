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
        button.titleLabel?.font = UIFont(name: "NanumSquareB", size: 14)
        return button
    }()

    private let importanceOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("중요도순", for: .normal)
        button.tintColor = #colorLiteral(red: 0.6039215686, green: 0.6352941176, blue: 0.662745098, alpha: 1)
        button.titleLabel?.font = UIFont(name: "NanumSquareB", size: 14)
        return button
    }()

    private let priceOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("가격순", for: .normal)
        button.tintColor = #colorLiteral(red: 0.6039215686, green: 0.6352941176, blue: 0.662745098, alpha: 1)
        button.titleLabel?.font = UIFont(name: "NanumSquareB", size: 14)
        return button
    }()


    private let settingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.tintColor = .white
        button.addTarget(self, action: #selector(settingAction), for: .touchUpInside)
        return button
    }()

    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.tintColor = .white
        button.addTarget(self, action: #selector(searchAction), for: .touchUpInside)

        return button
    }()

    private let writeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.tintColor = .white
        button.addTarget(self, action: #selector(writeAction), for: .touchUpInside)

        return button
    }()

    private lazy var filterStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [latestOrderButton, importanceOrderButton, priceOrderButton])
        stackView.axis = .horizontal
        stackView.spacing = 25
        return stackView
    }()

    private lazy var mainToolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 30))
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 10
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let setButton = UIBarButtonItem(customView: settingButton)
        let searchButton = UIBarButtonItem(customView: searchButton)
        let writeButton = UIBarButtonItem(customView: writeButton)
        setButton.title = "설정"
        toolBar.setItems([setButton,fixedSpace,searchButton, flexibleSpace, writeButton], animated: false)
        toolBar.isTranslucent = false
        toolBar.barTintColor = #colorLiteral(red: 0.3725490196, green: 0.5647058824, blue: 0.6588235294, alpha: 1)
        toolBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        toolBar.layer.shadowRadius = 2
        toolBar.layer.shadowOpacity = 0.5
        toolBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        return toolBar
    }()

    @objc
    func settingAction() {
        let settingVC = SettingViewController()
        navigationController?.pushViewController(settingVC, animated: true)
    }

    @objc
    func searchAction() {

    }

    @objc
    func writeAction() {

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }

    private func configureUI() {

        view.addSubview(keepItMainLabel)
        keepItMainLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(25)
        }

        view.addSubview(filterStackView)
        filterStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(25)
        }

        view.addSubview(mainToolBar)
        mainToolBar.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.height.equalTo(60)
        }
    }
}


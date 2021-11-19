//
//  ProductDetailViewController.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/11/18.
//

import UIKit
import SnapKit
import Alamofire

class ProductDetailViewController: UIViewController {

    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("닫기", for: .normal)
        button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        button.setTitleColor(UIColor.disabledGray, for: .normal)
        return button
    }()

    @objc
    func dismissAction() {
        dismiss(animated: true, completion: nil)
    }

    private let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.tintColor = .white
        button.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        return button
    }()

    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.tintColor = .white
        button.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)

        return button
    }()

    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up.circle.fill"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.tintColor = .white
        button.addTarget(self, action: #selector(shareAction), for: .touchUpInside)

        return button
    }()

    @objc
    func editAction() {
        print("눌림")
    }

    @objc
    func deleteAction() {
        print("눌림")
    }

    @objc
    func shareAction() {
        let addProductViewController = AddProductViewController()
        addProductViewController.navigationItem.title = "수정하기"
        navigationController?.pushViewController(addProductViewController, animated: true)
    }


    private lazy var mainToolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 30))
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 10
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let setButton = UIBarButtonItem(customView: editButton)
        let searchButton = UIBarButtonItem(customView: deleteButton)
        let writeButton = UIBarButtonItem(customView: shareButton)
        toolBar.setItems([setButton,fixedSpace,searchButton, flexibleSpace, writeButton], animated: false)
        toolBar.isTranslucent = false
        toolBar.barTintColor = UIColor.keepItBlue
        toolBar.layer.shadowColor = UIColor.black.cgColor
        toolBar.layer.shadowRadius = 2
        toolBar.layer.shadowOpacity = 0.5
        toolBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        return toolBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        configureLayout()
    }


    private func configureLayout() {
        view.addSubview(mainToolBar)
        mainToolBar.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.height.equalTo(60)
        }

        view.addSubview(dismissButton)
        dismissButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(30)
        }
    }

}

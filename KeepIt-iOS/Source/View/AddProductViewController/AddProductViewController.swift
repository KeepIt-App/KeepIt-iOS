//
//  AddProductViewController.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/11/17.
//

import UIKit
import SnapKit

class AddProductViewController: UIViewController {

    private let addProductMainLabel: UILabel = {
        let label = UILabel()
        label.text = "추가하기"
        label.font = UIFont(name: "NanumSquareEB", size: 25)
        label.textColor = #colorLiteral(red: 0.1882352941, green: 0.1882352941, blue: 0.1882352941, alpha: 1)

        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.addBackButton()
        configureLayout()
        configureNavigationBar()
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }

    private func configureLayout() {
    }
}

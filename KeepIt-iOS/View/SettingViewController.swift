//
//  SettingViewController.swift
//  KeepIt-iOS
//
//  Created by ITlearning on 2021/10/28.
//

import UIKit
import SnapKit

class SettingViewController: UIViewController {

    let helloLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello"

        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureLayout()
    }

    private func configureLayout() {
        view.addSubview(helloLabel)
        helloLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(50)
        }
    }
}

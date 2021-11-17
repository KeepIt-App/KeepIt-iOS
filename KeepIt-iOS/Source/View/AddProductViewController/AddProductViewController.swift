//
//  AddProductViewController.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/11/17.
//

import UIKit
import SnapKit

class AddProductViewController: UIViewController {

    private let imageSelectView = ImageSelectView()
    private let ratingStarView = RatingStarView()

    private let addProductMainLabel: UILabel = {
        let label = UILabel()
        label.text = "추가하기"
        label.font = UIFont(name: "NanumSquareEB", size: 25)
        label.textColor = #colorLiteral(red: 0.1882352941, green: 0.1882352941, blue: 0.1882352941, alpha: 1)

        return label
    }()

    private let priorityLabel: UILabel = {
        let label = UILabel()
        label.text = "우선순위를 매긴다면?"
        label.font = UIFont(name: "NanumSquareEB", size: 13)
        label.textColor = UIColor.disabledAllGray
        return label
    }()

    private let addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.disabledGray
        button.setTitle("등록하기", for: .normal)
        button.titleLabel?.font = UIFont(name: "NanumSquareEB", size: 16)
        button.layer.cornerRadius = 8
        button.setTitleColor(UIColor.white, for: .normal)

        return button
    }()

    private lazy var buttonView: UIView = {
        let buttonView = UIView()
        let grayView = UIView()
        grayView.backgroundColor = UIColor.disabledGray
        grayView.alpha = 0.5
        buttonView.addSubview(grayView)
        grayView.snp.makeConstraints {
            $0.top.equalTo(buttonView.snp.top)
            $0.leading.equalTo(buttonView.snp.leading)
            $0.trailing.equalTo(buttonView.snp.trailing)
            $0.height.equalTo(0.3)
        }
        buttonView.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.leading.equalTo(buttonView.snp.leading).offset(30)
            $0.trailing.equalTo(buttonView.snp.trailing).offset(-30)
            $0.top.equalTo(buttonView.snp.top).offset(15)
            $0.bottom.equalTo(buttonView.snp.bottom).offset(-15)
        }
        return buttonView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.addBackButton()
        configureLayout()
        configureNavigationBar()
    }

    @objc
    func starButtonAction(sender: UIButton) {

    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        guard let largeFont = UIFont(name: "NanumSquareEB", size: 28) else { return }
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : largeFont, NSAttributedString.Key.foregroundColor : UIColor.defaultBlack ]
    }

    private func configureLayout() {
        view.addSubview(imageSelectView)
        imageSelectView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(15)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-15)
            $0.height.equalTo(100)
        }

        let nameTextField = AddTextFieldView()
        nameTextField.configurePlaceHolder("이름을 입력하세요(필수)")
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(imageSelectView.snp.bottom).offset(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(15)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-15)
            $0.height.equalTo(50)
        }

        let priceTextField = AddTextFieldView()
        priceTextField.configurePlaceHolder("가격을 입력해주세요 (단위: 원, 필수)")
        view.addSubview(priceTextField)
        priceTextField.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(15)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(15)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-15)
            $0.height.equalTo(50)
        }

        let linkTextField = AddTextFieldView()
        view.addSubview(linkTextField)
        linkTextField.configurePlaceHolder("링크를 입력해주세요")
        linkTextField.snp.makeConstraints {
            $0.top.equalTo(priceTextField.snp.bottom).offset(15)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(15)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-15)
            $0.height.equalTo(50)
        }

        let memoTextField = AddTextFieldView()
        view.addSubview(memoTextField)
        memoTextField.configurePlaceHolder("간단한 메모를 남겨주세요")
        memoTextField.snp.makeConstraints {
            $0.top.equalTo(linkTextField.snp.bottom).offset(15)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(15)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-15)
            $0.height.equalTo(50)
        }

        view.addSubview(priorityLabel)
        priorityLabel.snp.makeConstraints {
            $0.top.equalTo(memoTextField.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }

        view.addSubview(ratingStarView)
        ratingStarView.snp.makeConstraints {
            $0.top.equalTo(priorityLabel.snp.bottom).offset(15)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(view.frame.width/5)
            $0.height.equalTo(50)
        }

        view.addSubview(buttonView)
        buttonView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.height.equalTo(80)
        }
    }
}

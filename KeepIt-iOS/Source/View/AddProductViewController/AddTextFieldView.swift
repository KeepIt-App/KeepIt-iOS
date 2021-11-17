//
//  AddTextFieldView.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/11/18.
//

import UIKit

class AddTextFieldView: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configurePlaceHolder(_ text: String) {
        self.placeholder = text
    }

    private func configureTextField() {
        delegate = self
        self.font = UIFont(name: "NanumSquareB", size: 15)
        self.clearButtonMode = UITextField.ViewMode.whileEditing
        self.borderStyle = UITextField.BorderStyle.roundedRect
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 3
        self.layer.borderColor = UIColor.init(white: 0.5, alpha: 1).cgColor
    }
}

extension AddTextFieldView: UITextFieldDelegate {

}

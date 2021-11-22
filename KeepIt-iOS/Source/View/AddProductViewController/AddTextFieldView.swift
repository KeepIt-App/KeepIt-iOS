//
//  AddTextFieldView.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/11/18.
//

import UIKit
import Combine

class AddTextFieldView: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configurePlaceHolder(_ text: String) {
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.disabledAllGray])
        //self.placeholder = text
    }

    private func configureTextField() {
        delegate = self
        self.font = UIFont(name: "NanumSquareB", size: 15)
        self.clearButtonMode = UITextField.ViewMode.whileEditing
        self.borderStyle = UITextField.BorderStyle.roundedRect
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.disabledAllGray.cgColor
    }
}

extension AddTextFieldView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
}

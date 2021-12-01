//
//  AddTextFieldView.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/11/18.
//

import UIKit
import Combine
class AddTextFieldView: UITextField {

    let viewModel = AddProductViewModel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurePlaceHolder(_ text: String) {
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.disabledAllGray])
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

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0

        if let removeAllSeprator = textField.text?.replacingOccurrences(of: formatter.groupingSeparator, with: "") {
            var beforeForemattedString = removeAllSeprator + string
            if formatter.number(from: string) != nil {
                if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber) {
                    textField.text = formattedString
                    viewModel.addProductPrice = formattedString
                    return false
                }
            } else {
                if string == "" {
                    let lastIndex = beforeForemattedString.index(beforeForemattedString.endIndex, offsetBy: -1)
                    beforeForemattedString = String(beforeForemattedString[..<lastIndex])
                    if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber) {
                        textField.text = formattedString
                        return false
                    }
                }
            }
        }

        return true
    }
}

//
//  UIScrollView.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/11/18.
//

import UIKit

extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}

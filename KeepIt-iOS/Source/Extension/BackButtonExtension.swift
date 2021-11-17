//
//  BackButtonExtension.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/11/11.
//

import UIKit

extension UIViewController {

    func addBackButton() {
        let back = UIBarButtonItem()
        back.title = "Back"
        back.tintColor = UIColor.defaultBlack
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = back
    }
}

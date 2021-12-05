//
//  UICollectionView.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/12/05.
//

import UIKit
import Differ

extension UICollectionView {
    func reloadChanges<T: Collection>(from old: T, to new: T) where T.Element: Equatable {
        animateItemChanges(oldData: old, newData: new, updateData: {})
    }
}

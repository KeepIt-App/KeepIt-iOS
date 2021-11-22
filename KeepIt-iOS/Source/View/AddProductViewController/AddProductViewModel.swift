//
//  AddProductViewModel.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/11/19.
//

import UIKit
import Combine

class AddProductViewModel {
    @Published var addProductName: String = ""
    @Published var addProductPrice: String = ""
    @Published var addProductLink: String = ""
    @Published var addProductMemo: String = ""
    @Published var addProductRatingStar: Float = 0.0

    var cancelables = Set<AnyCancellable>()

    private(set) lazy var isInvalid = Publishers.CombineLatest($addProductName, $addProductPrice)
        .map { $0.count > 2 && $1.count > 2 }
        .eraseToAnyPublisher()

    

}

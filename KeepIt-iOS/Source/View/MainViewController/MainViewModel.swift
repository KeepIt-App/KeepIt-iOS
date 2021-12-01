//
//  Product.swift
//  KeepIt-iOS
//
//  Created by ITlearning on 2021/10/08.
//

import UIKit
import Combine

final class MainViewModel: ViewModel {

    private var coreData = CoreDataManager.shared
    var currentData = CoreDataManager.shared.readAllProductList()
    struct Action {
        let fetch = PassthroughSubject<Void, Never>()
        let refresh = PassthroughSubject<Void, Never>()
    }

    struct State {
        let posts = CurrentValueSubject<[ProductModel], Never>([])
    }

    let action = Action()
    let state = State()

    func changeData(product: [Product]) {
        currentData = product
    }
}

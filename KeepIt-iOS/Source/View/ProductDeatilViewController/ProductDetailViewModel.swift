//
//  ProductDetailViewModel.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/12/05.
//

import Alamofire
import Combine
import CombineCocoa
import Foundation

final class ProductDetailViewModel: ViewModel {

    struct Action {
        let load = PassthroughSubject<Double, Never>()
    }

    struct State {
        let product = CurrentValueSubject<ProductModel?, Never>(nil)
    }

    let action = Action()
    let state = State()
    var cancelables = Set<AnyCancellable>()

    init() {
        action.load
            .receive(on: DispatchQueue.main)
            .sink { [weak self] idx in
                print(idx)
            }
            .store(in: &cancelables)
    }
}

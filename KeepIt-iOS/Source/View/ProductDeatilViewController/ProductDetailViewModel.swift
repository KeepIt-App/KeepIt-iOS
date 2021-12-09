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

    private let mainViewModel = MainViewModel()

    struct Action {
        let load = PassthroughSubject<Product, Never>()
    }

    struct State {
        let selectProduct = CurrentValueSubject<Product?, Never>(nil)
    }

    let action = Action()
    let state = State()
    var cancelables = Set<AnyCancellable>()

    init() {
        action.load
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] data in
                self?.state.selectProduct.send(data)
            }
            .store(in: &cancelables)
    }
}

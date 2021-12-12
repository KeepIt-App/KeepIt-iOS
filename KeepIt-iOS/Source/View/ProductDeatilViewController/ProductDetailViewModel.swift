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
import OpenGraph

final class ProductDetailViewModel: ViewModel {

    private let mainViewModel = MainViewModel()

    struct Action {
        let load = PassthroughSubject<Product, Never>()
        let openGraphFetch = PassthroughSubject<String, Never>()
        let openGraphImage = PassthroughSubject<String, Never>()
        let moveSafari = PassthroughSubject<Void, Never>()
    }

    struct State {
        let selectProduct = CurrentValueSubject<Product?, Never>(nil)
        let openGraph = CurrentValueSubject<OpenGraph?, Never>(nil)
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

        action.openGraphFetch
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .sink { url in
                print(url)
                guard let ogUrl = URL(string: url) else { return }
                OpenGraph.fetch(url: ogUrl) { result in
                    switch result {
                    case .success(let og):
                        print(og)
                        self.state.openGraph.send(og)
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.state.openGraph.send(nil)
                    }
                }
            }
            .store(in: &cancelables)

        action.moveSafari
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let moveUrl = self?.state.openGraph.value?[.url] else { return }
                guard let url = URL(string: moveUrl) else { return }
                UIApplication.shared.open(url, options: [:])
            }
            .store(in: &cancelables)
    }
}

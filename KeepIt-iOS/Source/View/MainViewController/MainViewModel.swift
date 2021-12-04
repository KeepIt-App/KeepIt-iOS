//
//  Product.swift
//  KeepIt-iOS
//
//  Created by ITlearning on 2021/10/08.
//

import UIKit
import Combine

enum FetchFilter: Int {
    case latest = 1
    case rating = 2
    case price = 3
}

final class MainViewModel: ViewModel {

    private var cancellables = Set<AnyCancellable>()
    struct Action {
        let fetch = PassthroughSubject<Int, Never>()
        let refresh = PassthroughSubject<Int, Never>()
        let search = PassthroughSubject<String, Never>()
    }

    struct State {
        let posts = CurrentValueSubject<[Product], Never>([])
    }

    let action = Action()
    let state = State()

    init() {
        action.fetch
            .receive(on: DispatchQueue.main)
            .sink { idx in
                guard let index: FetchFilter = FetchFilter.init(rawValue: idx) else { return }
                switch index {
                case .latest:
                    DispatchQueue.global(qos: .background).async {
                        CoreDataManager.shared.readProductList(tag: index.rawValue) { data in
                            self.state.posts.send(data)
                        }
                    }
                case .price:
                    DispatchQueue.global(qos: .background).async {
                        CoreDataManager.shared.readProductList(tag: index.rawValue) { data in
                            self.state.posts.send(data)
                        }
                    }
                case .rating:
                    DispatchQueue.global(qos: .background).async {
                        CoreDataManager.shared.readProductList(tag: index.rawValue) { data in
                            self.state.posts.send(data)
                        }
                    }
                }

            }
            .store(in: &cancellables)

        action.refresh
            .receive(on: DispatchQueue.main)
            .sink { [weak self] idx in
                self?.action.fetch.send(idx)
            }
            .store(in: &cancellables)

        action.search
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.global())
            .sink { [weak self] searchText in
                if searchText == "" {
                    self?.action.refresh.send(CoreDataManager.shared.selecFilterIndex)
                } else {
                    let filter = self?.state.posts.value.filter{ $0.productName?.contains(searchText) != false }

                    self?.state.posts.send(filter ?? [])
                }
            }
            .store(in: &cancellables)

        action.fetch.send(1)
    }
}

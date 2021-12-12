//
//  AddProductViewModel.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/11/19.
//

import UIKit
import Combine
protocol ViewModel {

    associatedtype Action
    associatedtype State

    var action: Action { get }
    var state: State { get }
}

final class AddProductViewModel: ViewModel {

    @Published var addProductName: String? = nil
    @Published var addProductPrice: String? = nil
    @Published var addProductLink: String? = nil
    @Published var addProductMemo: String? = nil
    @Published var addProductImage: UIImage? = nil
    var itemProvider: [NSItemProvider] = []
    
    struct Action {
        let save = PassthroughSubject<Double, Never>()
        let load = PassthroughSubject<Product, Never>()
        let edit = PassthroughSubject<Double, Never>()
    }

    struct State {
        let products = CurrentValueSubject<String, Never>("")
        let editData = CurrentValueSubject<Product?, Never>(nil)
        let flag = CurrentValueSubject<Bool, Never>(false)
    }

    let action = Action()
    let state = State()
    var cancelables = Set<AnyCancellable>()
    private var coreData = CoreDataManager.shared

    private(set) lazy var isInvalid = Publishers.CombineLatest($addProductName, $addProductPrice)
        .map { $0?.count ?? 0 > 1 && $1?.count ?? 0 > 1 }
        .eraseToAnyPublisher()

    init() {
        action.save
            .receive(on: DispatchQueue.global())
            .sink { [weak self] rating in
                self?.saveProduct(rating: rating)

            }
            .store(in: &cancelables)

        action.load
            .receive(on: DispatchQueue.global())
            .sink { data in
                self.state.editData.send(data)
                self.state.flag.send(true)
            }
            .store(in: &cancelables)

        action.edit
            .receive(on: DispatchQueue.global())
            .sink { rating in
                let filter = self.addProductPrice?.filter{ $0 != "," } ?? "0"
                guard let price = Int(filter) else { return }
                guard let data = self.state.editData.value else { return }
                CoreDataManager.shared.editProduct(data, productModel: ProductModel(productImage: self.addProductImage?.pngData() ?? Data(), productName: self.addProductName ?? "", productPrice: Int64(price), productLink: self.addProductLink ?? "", productMemo: self.addProductMemo ?? "", productRatingStar: rating, addDate: Date().timeIntervalSince1970))
            }
            .store(in: &cancelables)

    }

    private func saveProduct(rating: Double) {
        let filter = addProductPrice?.filter{ $0 != "," } ?? "0"
        guard let price = Int(filter) else { return }
        coreData.createProduct(productModel: ProductModel(productImage: addProductImage?.pngData() ?? Data(), productName: addProductName ?? "", productPrice: Int64(price), productLink: addProductLink ?? "", productMemo: addProductMemo ?? "", productRatingStar: rating, addDate: Date().timeIntervalSince1970))
        coreData.saveContext()
    }
}

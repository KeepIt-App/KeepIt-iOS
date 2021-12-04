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

class AddProductViewModel: ViewModel {

    @Published var addProductName: String? = nil
    @Published var addProductPrice: String? = nil
    @Published var addProductLink: String? = nil
    @Published var addProductMemo: String? = nil
    @Published var addProductImage: UIImage? = nil
    var itemProvider: [NSItemProvider] = []
    
    struct Action {
        let save = PassthroughSubject<Double, Never>()
    }

    struct State {
        let products = CurrentValueSubject<String, Never>("")
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
    }

    func saveProduct(rating: Double) {
        let filter = addProductPrice?.filter{ $0 != "," } ?? "0"
        guard let price = Int(filter) else { return }
        coreData.createProduct(productModel: ProductModel(productImage: addProductImage?.pngData() ?? Data(), productName: addProductName ?? "", productPrice: Int32(price), productLink: addProductLink ?? "", productMemo: addProductMemo ?? "", productRatingStar: rating, addDate: Date().timeIntervalSince1970))
        coreData.saveContext()
    }
}

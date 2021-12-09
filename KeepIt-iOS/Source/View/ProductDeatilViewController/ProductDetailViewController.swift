//
//  ProductDetailViewController.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/11/18.
//

import Alamofire
import Combine
import CombineCocoa
import UIKit
import SnapKit

class ProductDetailViewController: UIViewController {

    override func viewDidLayoutSubviews() {
        scrollView.updateContentView()
    }

    weak var viewModel: ProductDetailViewModel?
    var cancellables = Set<AnyCancellable>()

    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()

    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("닫기", for: .normal)
        button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        button.setTitleColor(UIColor.disabledGray, for: .normal)
        return button
    }()

    @objc
    func dismissAction() {
        dismiss(animated: true, completion: nil)
    }

    private let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.tintColor = .white
        button.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        return button
    }()

    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.tintColor = .white
        button.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)

        return button
    }()

    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up.circle.fill"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.tintColor = .white
        button.addTarget(self, action: #selector(shareAction), for: .touchUpInside)

        return button
    }()

    @objc
    func editAction() {
        print("눌림")
    }

    @objc
    func deleteAction() {
        print("눌림")
    }

    @objc
    func shareAction() {
        let addProductViewController = AddProductViewController()
        addProductViewController.navigationItem.title = "수정하기"
        navigationController?.pushViewController(addProductViewController, animated: true)
    }

    private lazy var mainToolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 30))
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 10
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let setButton = UIBarButtonItem(customView: editButton)
        let searchButton = UIBarButtonItem(customView: deleteButton)
        let writeButton = UIBarButtonItem(customView: shareButton)
        toolBar.setItems([setButton,fixedSpace,searchButton, flexibleSpace, writeButton], animated: false)
        toolBar.isTranslucent = false
        toolBar.barTintColor = UIColor.keepItBlue
        toolBar.layer.shadowColor = UIColor.black.cgColor
        toolBar.layer.shadowRadius = 2
        toolBar.layer.shadowOpacity = 0.5
        toolBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        return toolBar
    }()

    private let scrollView = UIScrollView()

    init(viewModel: ProductDetailViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        scrollView.delegate = self
        view.backgroundColor = UIColor.white
        configureLayout()
    }
    private func bindViewModel() {
        viewModel?.state.selectProduct
            .receive(on: DispatchQueue.main)
            .sink { data in
                self.productImageView.image = UIImage(data: data?.productImage ?? Data())
            }
            .store(in: &cancellables)
    }


    private func configureLayout() {
        view.addSubview(scrollView)
        view.addSubview(mainToolBar)
        scrollView.addSubview(dismissButton)
        scrollView.addSubview(productImageView)

        mainToolBar.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.height.equalTo(60)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(mainToolBar.snp.top)
        }

        
        dismissButton.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(30)
            $0.leading.equalTo(scrollView.snp.leading).offset(30)
        }

        productImageView.snp.makeConstraints {
            $0.top.equalTo(dismissButton.snp.bottom).offset(10)
            $0.centerX.equalTo(scrollView.snp.centerX)
            $0.width.equalTo(view.frame.width - 20)
            $0.height.equalTo(300)
        }

    }

}

extension ProductDetailViewController: UIScrollViewDelegate {
}

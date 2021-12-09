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
import Cosmos

class ProductDetailViewController: UIViewController {

    override func viewDidLayoutSubviews() {
        scrollView.updateContentView()
    }

    weak var viewModel: ProductDetailViewModel?
    var cancellables = Set<AnyCancellable>()
    // MARK: - 제품 표시 UI 관련 세팅
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()

    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NanumSquareEB", size: 20)
        label.textColor = .defaultBlack

        return label
    }()

    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NanumSquareB", size: 18)
        label.textColor = .disabledAllGray

        return label
    }()

    private lazy var productNameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productNameLabel, productPriceLabel])
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.alignment = .leading

        return stackView
    }()

    private let ratingStarView: CosmosView = {
        let starView = CosmosView()
        starView.settings.filledColor = UIColor.keepItBlue
        starView.settings.emptyColor = UIColor.disabledGray
        starView.settings.emptyBorderWidth = 0
        starView.settings.filledBorderWidth = 0
        starView.settings.starSize = 15
        starView.settings.starMargin = 2
        starView.isUserInteractionEnabled = false
        return starView
    }()

    private let memoLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "text.bubble.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .keepItBlue
        return imageView
    }()

    private let productMemoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NanumSquareB", size: 15)
        label.textColor = .disabledAllGray
        return label
    }()

    private lazy var memoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [memoLogoImageView, productMemoLabel])
        memoLogoImageView.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        }
        stackView.spacing = 10

        return stackView
    }()



    // MARK: - 버튼 관련 UI 세팅
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(UIColor.disabledGray, for: .normal)
        return button
    }()

    private let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.tintColor = .white
        return button
    }()

    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.tintColor = .white
        return button
    }()

    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up.circle.fill"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.tintColor = .white
        return button
    }()

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
        setButtonBind()
        configureLayout()
        scrollView.delegate = self
        view.backgroundColor = UIColor.white
    }

    private func setButtonBind() {

        dismissButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink {
                self.dismiss(animated: true, completion: nil)
            }
            .store(in: &cancellables)

        editButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink {
                print("눌림")
            }
            .store(in: &cancellables)

        deleteButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink {
                print("눌림")
            }
            .store(in: &cancellables)

        shareButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                print("눈림")
            }
            .store(in: &cancellables)

    }

    private func bindViewModel() {
        viewModel?.state.selectProduct
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { data in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    let price = self.decimal(price: data.productPrice)
                    self.productImageView.image = UIImage(data: data.productImage ?? Data())
                    self.productNameLabel.text = data.productName
                    self.productPriceLabel.text = "₩"+price+"원"
                    self.ratingStarView.rating = data.productRatingStar
                    self.productMemoLabel.text = data.productMemo ?? "등록된 메모가 없습니다"
                }
            }
            .store(in: &cancellables)
    }

    private func configureLayout() {
        view.addSubview(scrollView)
        view.addSubview(mainToolBar)
        scrollView.addSubview(dismissButton)
        scrollView.addSubview(productImageView)
        scrollView.addSubview(productNameStackView)
        scrollView.addSubview(ratingStarView)
        scrollView.addSubview(memoStackView)

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
            $0.width.equalTo(view.frame.width - 25)
            $0.height.equalTo(250)
        }

        productNameStackView.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(25)
            $0.leading.equalTo(scrollView.snp.leading).offset(25)
        }

        ratingStarView.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(25)
            $0.trailing.equalTo(productImageView.snp.trailing).inset(15)
        }

        memoStackView.snp.makeConstraints {
            $0.top.equalTo(productNameStackView.snp.bottom).offset(20)
            $0.leading.equalTo(scrollView.snp.leading).offset(25)
        }
    }

}

extension ProductDetailViewController: UIScrollViewDelegate {
}


extension ProductDetailViewController {
    func decimal(price: Int64) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        let result = numberFormatter.string(from: NSNumber(value: price)) ?? ""

        return result
    }
}

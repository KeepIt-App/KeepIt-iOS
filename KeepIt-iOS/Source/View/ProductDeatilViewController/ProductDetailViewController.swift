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
    private let linkStackView = ReuseStackView()
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

    private let stackLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "text.bubble.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .keepItBlue
        return imageView
    }()

    private let productStackLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NanumSquareB", size: 15)
        label.textColor = .disabledAllGray
        return label
    }()

    private lazy var reuseStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stackLogoImageView, productStackLabel])
        stackLogoImageView.snp.makeConstraints {
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
        self.addBackButton()
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
                let editViewModel = AddProductViewModel()
                guard let data = self.viewModel?.state.selectProduct.value else { return }
                editViewModel.action.load.send(data)
                let editViewController = AddProductViewController(viewModel: editViewModel)
                editViewController.navigationItem.title = "수정하기"
                self.navigationController?.pushViewController(editViewController, animated: true)
            }
            .store(in: &cancellables)

        deleteButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink {
                self.configureAlertAction()
                self.dismiss(animated: true, completion: nil)
            }
            .store(in: &cancellables)

        shareButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                print("눈림")
            }
            .store(in: &cancellables)

        linkStackView.linkMoveButton.tapPublisher
            .receive(on: RunLoop.main)
            .sink {
                self.viewModel?.action.moveSafari.send(())
            }
            .store(in: &cancellables)

    }

    private func bindViewModel() {
        DispatchQueue.global().async {
            self.viewModel?.action.openGraphFetch
                .send(self.viewModel?.state.selectProduct.value?.productLink ?? "")
        }

        viewModel?.state.selectProduct
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { data in
                guard let data = data else { return }
                guard let memo = data.productMemo else { return }
                guard let link = data.productLink else { return }
                DispatchQueue.main.async {
                    let price = self.decimal(price: data.productPrice)
                    self.productImageView.image = UIImage(data: data.productImage ?? Data())
                    self.productNameLabel.text = data.productName
                    self.productPriceLabel.text = "₩"+price+"원"
                    self.ratingStarView.rating = data.productRatingStar
                    self.productStackLabel.text = memo != "" ? memo : "등록된 메모가 없습니다"
                    if link != "" { self.linkStackView.showOpenGraph() }
                }
            }
            .store(in: &cancellables)

        viewModel?.state.openGraph
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .sink { ogData in
                guard let data = ogData else {
                    self.linkStackView.loadFail()
                    return
                }
                print(data)
                DispatchQueue.main.async {
                    self.linkStackView.configureOpenGraphData(data: data)
                }
            }
            .store(in: &cancellables)

    }

    private func configureAlertAction() {
        let alertController = UIAlertController(title: "아이템 삭제", message: "아이템을 삭제하시겠어요?", preferredStyle: .alert)

        let doneButton = UIAlertAction(title: "삭제하기", style: .destructive) { [weak self] _ in
            self?.viewModel?.action.deleteProduct.send(())
        }

        let cancelButton = UIAlertAction(title: "취소", style: .default, handler: nil)

        alertController.addAction(cancelButton)
        alertController.addAction(doneButton)

        self.present(alertController, animated: true, completion: nil)

    }

    private func configureLayout() {
        view.addSubview(scrollView)
        view.addSubview(mainToolBar)
        scrollView.addSubview(productImageView)
        scrollView.addSubview(productNameStackView)
        scrollView.addSubview(ratingStarView)
        scrollView.addSubview(reuseStackView)
        scrollView.addSubview(linkStackView)

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

        productImageView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(10)
            $0.centerX.equalTo(scrollView.snp.centerX)
            $0.width.equalTo(view.frame.width - 25)
            $0.height.equalTo(300)
        }

        productNameStackView.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(25)
            $0.leading.equalTo(scrollView.snp.leading).offset(25)
        }

        ratingStarView.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(25)
            $0.trailing.equalTo(productImageView.snp.trailing).inset(15)
        }

        reuseStackView.snp.makeConstraints {
            $0.top.equalTo(productNameStackView.snp.bottom).offset(20)
            $0.leading.equalTo(scrollView.snp.leading).offset(25)
        }

        linkStackView.snp.makeConstraints {
            $0.top.equalTo(reuseStackView.snp.bottom).offset(20)
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(250)
            $0.width.equalTo(view.frame.width - 45)

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

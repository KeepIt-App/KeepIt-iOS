//
//  AddProductViewController.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/11/17.
//

import UIKit
import SnapKit
import Cosmos
import Combine
import CombineCocoa
import PhotosUI

class AddProductViewController: UIViewController {

    override func viewDidLayoutSubviews() {
        addScrollView.updateContentView()
    }
    
    private lazy var nameTextField = AddTextFieldView()
    private lazy var priceTextField = AddTextFieldView()
    private lazy var linkTextField = AddTextFieldView()
    private lazy var memoTextField = AddTextFieldView()
    private let imageSelectView = ImageSelectView()
    private let numberFormatter = NumberFormatter()

    var addProductViewModel: AddProductViewModel!
    var cancellables = Set<AnyCancellable>()
    

    private let addProductMainLabel: UILabel = {
        let label = UILabel()
        label.text = "추가하기"
        label.font = UIFont(name: "NanumSquareEB", size: 25)
        label.textColor = #colorLiteral(red: 0.1882352941, green: 0.1882352941, blue: 0.1882352941, alpha: 1)

        return label
    }()

    private let priorityLabel: UILabel = {
        let label = UILabel()
        label.text = "우선순위를 매긴다면?"
        label.font = UIFont(name: "NanumSquareEB", size: 13)
        label.textColor = UIColor.disabledAllGray
        return label
    }()

    private let addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.disabledGray
        button.setTitle("등록하기", for: .normal)
        button.titleLabel?.font = UIFont(name: "NanumSquareEB", size: 16)
        button.layer.cornerRadius = 8
        button.setTitleColor(UIColor.white, for: .normal)
        button.isEnabled = false
        return button
    }()

    private let ratingStarView: CosmosView = {
        let starView = CosmosView()
        starView.settings.filledColor = UIColor.keepItBlue
        starView.settings.emptyColor = UIColor.disabledAllGray
        starView.settings.emptyBorderWidth = 0
        starView.settings.filledBorderWidth = 0
        starView.settings.starSize = 35
        starView.settings.starMargin = 5
        starView.rating = 0
        return starView
    }()

    private lazy var buttonView: UIView = {
        let buttonView = UIView()
        let grayView = UIView()
        grayView.backgroundColor = UIColor.disabledGray
        grayView.alpha = 0.5
        buttonView.addSubview(grayView)
        grayView.snp.makeConstraints {
            $0.top.equalTo(buttonView.snp.top)
            $0.leading.equalTo(buttonView.snp.leading)
            $0.trailing.equalTo(buttonView.snp.trailing)
            $0.height.equalTo(0.3)
        }
        buttonView.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.leading.equalTo(buttonView.snp.leading).offset(30)
            $0.trailing.equalTo(buttonView.snp.trailing).offset(-30)
            $0.top.equalTo(buttonView.snp.top).offset(15)
            $0.bottom.equalTo(buttonView.snp.bottom).offset(-15)
        }
        return buttonView
    }()

    private let spaceView = UIView()
    private let addScrollView = UIScrollView()

    init(viewModel: AddProductViewModel) {
        super.init(nibName: nil, bundle: nil)
        print(viewModel)
        self.addProductViewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        addScrollView.delegate = self
        self.addBackButton()
        configureLayout()
        configureNavigationBar()
        setUpBindings()
        configureNumber()
        bindViewModel()
    }

    func selectPhoto() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }

    private func configureNumber() {
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale.current
    }

    private func bindViewModel() {
        addProductViewModel.state.editData
            .receive(on: DispatchQueue.main)
            .sink { data in
                guard let data = data else { return }
                self.editMode(product: data)
            }
            .store(in: &cancellables)
    }

    private func setUpBindings() {

        imageSelectView.selectButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                self.selectPhoto()
            }
            .store(in: &cancellables)

        nameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.addProductName, on: addProductViewModel)
            .store(in: &cancellables)

        priceTextField.textPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.addProductPrice, on: addProductViewModel)
            .store(in: &cancellables)

        priceTextField.keyboardType = .numberPad

        linkTextField.textPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.addProductLink, on: addProductViewModel)
            .store(in: &cancellables)

        memoTextField.textPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.addProductMemo, on: addProductViewModel)
            .store(in: &cancellables)

        addProductViewModel.isInvalid
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: addButton)
            .store(in: &cancellables)

        addButton
            .publisher(for: \.isEnabled)
            .sink { enabled in
                if self.addProductViewModel.state.flag.value != true {
                    self.addButton.backgroundColor = UIColor.keepItBlue
                } else {
                    if enabled {
                        self.addButton.backgroundColor = UIColor.keepItBlue
                    } else {
                        self.addButton.backgroundColor = UIColor.disabledGray
                    }
                }
            }
            .store(in: &cancellables)

        addButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                if self?.addProductViewModel.state.flag.value == false {
                    self?.addProductViewModel.action.save.send(self?.ratingStarView.rating ?? 0.0)
                } else {
                    self?.addProductViewModel.action.edit.send(self?.ratingStarView.rating ?? 0.0)
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: Notification.Name.NSManagedObjectContextDidSave)
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &cancellables)
    }

    @objc
    func starButtonAction(sender: UIButton) {

    }

    private func configureNavigationBar() {

        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        guard let largeFont = UIFont(name: "NanumSquareEB", size: 28) else { return }
        navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : largeFont, NSAttributedString.Key.foregroundColor : UIColor.defaultBlack ]
    }

    private func fixImageOrientaion(image: UIImage) -> UIImage {
        if image.imageOrientation == .up {
            return image
        }

        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.draw(in: rect)
        guard let normalizedImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()

        return normalizedImage
    }

    private func editMode(product: Product) {
        guard let image = product.productImage else { return }
        DispatchQueue.global().async {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            guard let number = numberFormatter.string(from: NSNumber(value: product.productPrice)) else { return }
            DispatchQueue.main.async {
                self.priceTextField.text = number
            }
            self.addProductViewModel.addProductName = product.productName
            self.addProductViewModel.addProductLink = product.productLink
            self.addProductViewModel.addProductPrice = number
            self.addProductViewModel.addProductMemo = product.productMemo
            self.addProductViewModel.addProductImage = UIImage(data: image)
        }


        imageSelectView.loadSelectImage(image: UIImage(data: image) ?? UIImage())
        imageSelectView.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(addScrollView.snp.top).offset(15)
            $0.height.equalTo(300)
            $0.width.equalTo(view.frame.width*0.93)
        }
        nameTextField.text = product.productName
        linkTextField.text = product.productLink
        memoTextField.text = product.productMemo
        ratingStarView.rating = product.productRatingStar
        addButton.isEnabled = true
        addButton.backgroundColor = UIColor.keepItBlue
    }

    private func configureLayout() {

        view.addSubview(buttonView)
        view.addSubview(addScrollView)
        addScrollView.addSubview(imageSelectView)
        addScrollView.addSubview(nameTextField)
        addScrollView.addSubview(priceTextField)
        addScrollView.addSubview(linkTextField)
        addScrollView.addSubview(memoTextField)
        addScrollView.addSubview(priorityLabel)
        addScrollView.addSubview(ratingStarView)
        addScrollView.addSubview(spaceView)

        buttonView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.height.equalTo(80)
        }


        addScrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(buttonView.snp.top)
        }


        imageSelectView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(addScrollView.snp.top).offset(15)
            $0.height.equalTo(100)
            $0.width.equalTo(view.frame.width*0.93)
        }

        nameTextField.configurePlaceHolder("이름을 입력하세요(필수)")
        nameTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageSelectView.snp.bottom).offset(30)
            $0.width.equalTo(view.frame.width*0.93)
            $0.height.equalTo(50)
        }

        priceTextField.configurePlaceHolder("가격을 입력해주세요 (단위: 원, 필수)")
        priceTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameTextField.snp.bottom).offset(15)
            $0.width.equalTo(view.frame.width*0.93)
            $0.height.equalTo(50)
        }

        linkTextField.configurePlaceHolder("링크를 입력해주세요")
        linkTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(priceTextField.snp.bottom).offset(15)
            $0.width.equalTo(view.frame.width*0.93)
            $0.height.equalTo(50)
        }

    
        memoTextField.configurePlaceHolder("간단한 메모를 남겨주세요")
        memoTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(linkTextField.snp.bottom).offset(15)
            $0.width.equalTo(view.frame.width*0.93)
            $0.height.equalTo(50)
        }


        priorityLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(memoTextField.snp.bottom).offset(30)
        }


        ratingStarView.snp.makeConstraints {
            $0.top.equalTo(priorityLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }

        spaceView.snp.makeConstraints {
            $0.top.equalTo(ratingStarView.snp.bottom).offset(5)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(100)
            $0.bottom.equalTo(addScrollView.snp.bottom)
        }
    }
}


extension AddProductViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}


extension AddProductViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        addProductViewModel.itemProvider = results.map(\.itemProvider)
        if addProductViewModel.itemProvider.count != 0 {
            if addProductViewModel.itemProvider[0].canLoadObject(ofClass: UIImage.self) {
                addProductViewModel.itemProvider[0].loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.global().async {
                        guard let image = image as? UIImage else { return }
                        let orientImage = self.fixImageOrientaion(image: image)
                        print(image.size.width, image.size.height)
                        guard let resizeImage = image.size.width > 2000 && image.size.height > 2000 ?  orientImage.resized(withPercentage: 0.25) : orientImage.resized(withPercentage: 1) else { return }
                        self.addProductViewModel.addProductImage = resizeImage
                        DispatchQueue.main.async {
                            self.imageSelectView.loadSelectImage(image: resizeImage)
                            self.imageSelectView.snp.remakeConstraints {
                                $0.centerX.equalToSuperview()
                                $0.top.equalTo(self.addScrollView.snp.top).offset(15)
                                $0.height.equalTo(300)
                                $0.width.equalTo(self.view.frame.width*0.93)
                            }
                        }
                    }
                }
            }
        }
    }
}

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

    var addProductViewModel = AddProductViewModel()
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
        button.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        return button
    }()

    @objc
    func doneAction() {
    }

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

    private let addScrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        addScrollView.delegate = self
        self.addBackButton()
        configureLayout()
        configureNavigationBar()
        setUpBindings()
        configureNumber()
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
                if enabled {
                    self.addButton.backgroundColor = UIColor.keepItBlue
                } else {
                    self.addButton.backgroundColor = UIColor.disabledGray
                }
            }
            .store(in: &cancellables)

        addButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                print("눌림")
                self.addProductViewModel.action.save.send(self.ratingStarView.rating)
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
        nameTextField.tag = 1

        nameTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageSelectView.snp.bottom).offset(30)
            $0.width.equalTo(view.frame.width*0.93)
            $0.height.equalTo(50)
        }

        priceTextField.tag = 2
        priceTextField.configurePlaceHolder("가격을 입력해주세요 (단위: 원, 필수)")

        priceTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameTextField.snp.bottom).offset(15)
            $0.width.equalTo(view.frame.width*0.93)
            $0.height.equalTo(50)
        }

        linkTextField.tag = 3

        linkTextField.configurePlaceHolder("링크를 입력해주세요")
        linkTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(priceTextField.snp.bottom).offset(15)
            $0.width.equalTo(view.frame.width*0.93)
            $0.height.equalTo(50)
        }

        memoTextField.tag = 4

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
                    OperationQueue().addOperation {
                        OperationQueue.main.addOperation {
                            guard let image = image as? UIImage else { return }
                            let orientImage = self.fixImageOrientaion(image: image)
                            self.imageSelectView.loadSelectImage(image: orientImage)
                            self.addProductViewModel.addProductImage = orientImage
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

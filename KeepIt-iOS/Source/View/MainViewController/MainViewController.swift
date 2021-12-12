//
//  ViewController.swift
//  KeepIt-iOS
//
//  Created by ITlearning on 2021/09/26.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import Differ

class MainViewController: UIViewController {

    // MARK: - 뷰 라이프 사이클 설정
    override func viewWillAppear(_ animated: Bool) {
        print("바뀜")
        super.viewWillAppear(animated)
        NotificationCenter.default.publisher(for: Notification.Name.NSManagedObjectContextDidSave)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
                        self?.successView.alpha = 1.0
                    }, completion: { finished -> Void in
                        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseIn, animations: {
                            self?.successView.alpha = 0.0
                        })
                        DispatchQueue.global(qos: .background).async {
                            self?.viewModel.action.refresh.send(CoreDataManager.shared.selecFilterIndex)
                        }
                    })
                }
            }
            .store(in: &cancellables)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }

    // MARK: - 메인 뷰 기본 private 변수들
    private var searchButtonState = true
    private var sectionInset = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
    private let viewModel = MainViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var animateArray: [Product] = []
    private let successView = SaveSuccessView()
    // MARK: - 뷰 UI 선언
    private let keepItMainLabel: UILabel = {
        let label = UILabel()
        label.text = "KeepIt!"
        label.font = UIFont(name: "NanumSquareEB", size: 25)
        label.textColor = #colorLiteral(red: 0.1882352941, green: 0.1882352941, blue: 0.1882352941, alpha: 1)
        
        return label
    }()

    private let latestOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("최신순", for: .normal)
        button.tintColor = #colorLiteral(red: 0.6039215686, green: 0.6352941176, blue: 0.662745098, alpha: 1)
        button.titleLabel?.font = UIFont(name: "NanumSquareB", size: 14)
        button.tag = 1
        button.addTarget(self, action: #selector(filterButtonAction(sender:)), for: .touchUpInside)
        return button
    }()

    private let priorityOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("중요도순", for: .normal)
        button.tintColor = #colorLiteral(red: 0.6039215686, green: 0.6352941176, blue: 0.662745098, alpha: 1)
        button.titleLabel?.font = UIFont(name: "NanumSquareB", size: 14)
        button.tag = 2
        button.addTarget(self, action: #selector(filterButtonAction(sender:)), for: .touchUpInside)
        return button
    }()

    private let priceOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("가격순", for: .normal)
        button.tintColor = #colorLiteral(red: 0.6039215686, green: 0.6352941176, blue: 0.662745098, alpha: 1)
        button.titleLabel?.font = UIFont(name: "NanumSquareB", size: 14)
        button.tag = 3
        button.addTarget(self, action: #selector(filterButtonAction(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var buttonArray = [latestOrderButton, priorityOrderButton, priceOrderButton]

    @objc
    func filterButtonAction(sender: UIButton) {
        for btn in buttonArray {
            if btn.tag == sender.tag {
                sender.setTitleColor(UIColor.keepItBlue, for: .normal)
            } else {
                btn.setTitleColor(UIColor.disabledGray, for: .normal)
            }
        }
    }

    private let settingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.tintColor = .white
        button.addTarget(self, action: #selector(settingAction), for: .touchUpInside)
        return button
    }()

    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.tintColor = .white
        button.addTarget(self, action: #selector(searchAction), for: .touchUpInside)

        return button
    }()

    private let writeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.tintColor = .white
        button.addTarget(self, action: #selector(writeAction), for: .touchUpInside)

        return button
    }()

    private lazy var filterStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [latestOrderButton, priorityOrderButton, priceOrderButton])
        stackView.axis = .horizontal
        stackView.spacing = 25
        return stackView
    }()

    private lazy var mainToolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 30))
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 10
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let setButton = UIBarButtonItem(customView: settingButton)
        let searchButton = UIBarButtonItem(customView: searchButton)
        let writeButton = UIBarButtonItem(customView: writeButton)
        setButton.title = "설정"
        toolBar.setItems([setButton,fixedSpace,searchButton, flexibleSpace, writeButton], animated: false)
        toolBar.isTranslucent = false
        toolBar.barTintColor = UIColor.keepItBlue
        toolBar.layer.shadowColor = UIColor.black.cgColor
        toolBar.layer.shadowRadius = 2
        toolBar.layer.shadowOpacity = 0.5
        toolBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        return toolBar
    }()

    @objc
    func settingAction() {
        let settingVC = SettingViewController()
        CoreDataManager.shared.clearAllData()
        settingVC.navigationItem.title = "정보"
        navigationController?.pushViewController(settingVC, animated: true)
    }

    @objc
    func searchAction() {
        searchBarActivation()
    }

    @objc
    func writeAction() {
        let addProductViewController = AddProductViewController()
        addProductViewController.navigationItem.title = "추가하기"
        navigationController?.pushViewController(addProductViewController, animated: true)
    }

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력해주세요"
        searchBar.searchTextField.font = UIFont(name: "NanumSquareB", size: 13)
        searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: UISearchBar.Icon.search, state: .normal)
        searchBar.setImage(UIImage(systemName: "xmark.circle.fill"), for: .clear, state: .normal)
        searchBar.tintColor = UIColor.init(white: 0, alpha: 0.12)
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()

    private let mainCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()

    // MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
        configureUI()
        configureCollectionView()
        bindViewModel()
        configureFirstButton()
        setPublisherBind()
        setupLongGesture()
    }

    // MARK: - 뷰 구성 시작 시 필터 버튼 기본 설정
    private func configureFirstButton() {
        latestOrderButton.setTitleColor(UIColor.keepItBlue, for: .normal)
    }

    // MARK: - 메서드 환경 설정
    private func bindViewModel() {
        viewModel.state.posts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (data) in
                print("흐음")
                self?.mainCollectionView.reloadChanges(from: self?.animateArray ?? [], to: data)
                self?.animateArray = data
            }
            .store(in: &cancellables)
    }

    private func setupLongGesture() {
        let longPressed = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressed.minimumPressDuration = 0.5
        longPressed.delegate = self
        longPressed.delaysTouchesBegan = true
        mainCollectionView.addGestureRecognizer(longPressed)
    }

    @objc
    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != .began {
            return
        }

        let index = gestureRecognizer.location(in: mainCollectionView)

        if let indexPath = mainCollectionView.indexPathForItem(at: index) {
            print(indexPath.row)
            configureAlertAction(index: indexPath.row)
        }
    }

    private func setPublisherBind() {
        latestOrderButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                CoreDataManager.shared.selecFilterIndex = 1
                self?.viewModel.action.refresh.send(1)
                print(CoreDataManager.shared.selecFilterIndex)
            }
            .store(in: &cancellables)

        priorityOrderButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                CoreDataManager.shared.selecFilterIndex = 2
                self?.viewModel.action.refresh.send(2)
            }
            .store(in: &cancellables)

        priceOrderButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                CoreDataManager.shared.selecFilterIndex = 3
                self?.viewModel.action.refresh.send(3)
            }
            .store(in: &cancellables)

        searchBar.textDidChangePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.viewModel.action.search.send(searchText)
            }
            .store(in: &cancellables)
    }

    private func configureAlertAction(index: Int) {
        let alertController = UIAlertController(title: "아이템 삭제", message: "선택한 아이템을 삭제하시겠어요?", preferredStyle: .alert)

        let doneButton = UIAlertAction(title: "삭제하기", style: .destructive) { [weak self] _ in
            self?.viewModel.action.delete.send(index)
        }

        let cancelButton = UIAlertAction(title: "취소", style: .default, handler: nil)

        alertController.addAction(cancelButton)
        alertController.addAction(doneButton)

        self.present(alertController, animated: true, completion: nil)

    }

    private func configureCollectionView() {
        mainCollectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.cellId)
        let flow = UICollectionViewFlowLayout()
        flow.minimumLineSpacing = 1
        flow.minimumInteritemSpacing = 1
        mainCollectionView.backgroundColor = UIColor.init(white: 0.98, alpha: 1)
        mainCollectionView.delegate = self
        mainCollectionView.showsVerticalScrollIndicator = false
        mainCollectionView.dataSource = self
    }

    private func searchBarActivation() {
        if searchButtonState {

            mainCollectionView.snp.remakeConstraints {
                $0.top.equalTo(searchBar.snp.bottom).offset(5)
                $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
                $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
                $0.bottom.equalTo(mainToolBar.snp.top)
            }

            UIView.animate(withDuration: 0.2, delay: 0,options: .curveEaseInOut ,animations: {
                self.searchBar.alpha = 1.0
                self.searchBar.isUserInteractionEnabled = true
                self.view.layoutIfNeeded()
            })

            searchButtonState = !searchButtonState
        } else {

            mainCollectionView.snp.remakeConstraints {
                $0.top.equalTo(searchBar.snp.top).offset(5)
                $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
                $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
                $0.bottom.equalTo(mainToolBar.snp.top)
            }

            UIView.animate(withDuration: 0.2, delay: 0,options: .curveEaseOut ,animations: {
                self.searchBar.alpha = 0.0
                self.searchBar.isUserInteractionEnabled = false
                self.searchBar.text = ""
                self.view.layoutIfNeeded()
            })

            searchButtonState = !searchButtonState
        }

    }

    // MARK: - UI 세팅
    private func configureUI() {
        view.addSubview(keepItMainLabel)
        view.addSubview(searchBar)
        view.addSubview(filterStackView)
        view.addSubview(mainToolBar)
        view.addSubview(mainCollectionView)
        view.addSubview(successView)

        keepItMainLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(25)
        }

        searchBar.alpha = 0.0
        searchBar.snp.makeConstraints {
            $0.top.equalTo(keepItMainLabel.snp.bottom).offset(10)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(view.bounds.width - 20)
        }

        filterStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(25)
        }

        mainToolBar.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.height.equalTo(60)
        }

        mainCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(mainToolBar.snp.top)
        }

        view.bringSubviewToFront(mainToolBar)

        successView.alpha = 0.0
        successView.snp.makeConstraints {
            $0.bottom.equalTo(mainToolBar.snp.top).inset(5)
            $0.centerX.equalToSuperview()
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(50)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(50)
            $0.height.equalTo(50)
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.state.posts.value.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 8, bottom: 0, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let itemSize = ((collectionView.frame.width - 20) - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2

        if viewModel.state.posts.value[indexPath.row].productImage != nil {
            return CGSize(width: itemSize, height: 200)
        } else {
            return CGSize(width: itemSize, height: 60)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.cellId, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        DispatchQueue.global(qos: .userInitiated).async {
            let data = self.viewModel.state.posts.value[indexPath.row]
            let coreData = self.viewModel.state.posts.value[indexPath.row]
            guard let coreDataProductName = coreData.productName else { return }
            let coreDataProductPrice = coreData.productPrice
            cell.loadProduct(data.productImage ?? Data(), product: coreDataProductName, price: coreDataProductPrice)
                DispatchQueue.main.async {
                    cell.backgroundColor = UIColor.white
                }
            }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productViewModel = ProductDetailViewModel()
        DispatchQueue.global(qos: .background).async {
            productViewModel.action.load.send(self.viewModel.state.posts.value[indexPath.row])
        }
        let productDetailViewController = ProductDetailViewController(viewModel: productViewModel)
        productDetailViewController.modalPresentationStyle = .fullScreen
        present(productDetailViewController, animated: true, completion: nil)
    }

}


extension MainViewController: UIGestureRecognizerDelegate {

}

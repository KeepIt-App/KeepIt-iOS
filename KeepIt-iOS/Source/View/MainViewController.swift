//
//  ViewController.swift
//  KeepIt-iOS
//
//  Created by ITlearning on 2021/09/26.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    private var searchButtonState = true
    private var sectionInset = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)

    private var names = ["mac", "key"]
    private var product = ["맥북 딱 대", "키크론"]
    private var price = ["₩1,690,000원", "₩150,000원"]

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

    private let importanceOrderButton: UIButton = {
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

    private lazy var buttonArray = [latestOrderButton, importanceOrderButton, priceOrderButton]

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
        let stackView = UIStackView(arrangedSubviews: [latestOrderButton, importanceOrderButton, priceOrderButton])
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
        settingVC.navigationItem.title = "정보"
        navigationController?.pushViewController(settingVC, animated: true)
    }

    @objc
    func searchAction() {
        searchBarActivation()
    }

    @objc
    func writeAction() {

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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(white: 0.98, alpha: 1)
        configureUI()
        configureCollectionView()
    }

    private func configureCollectionView() {
        mainCollectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.cellId)
        let flow = UICollectionViewFlowLayout()
        flow.itemSize = CGSize(width: view.frame.width/2.25, height: 200)
        flow.sectionInset = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
        mainCollectionView.collectionViewLayout = flow
        mainCollectionView.backgroundColor = UIColor.init(white: 0.98, alpha: 1)
        mainCollectionView.delegate = self
        mainCollectionView.showsVerticalScrollIndicator = false
        mainCollectionView.dataSource = self
    }


    private func searchBarActivation() {
        if searchButtonState {
            UIView.animate(withDuration: 0.2, delay: 0,options: .curveEaseIn ,animations: {
                self.searchBar.alpha = 1.0
                self.searchBar.isUserInteractionEnabled = true
            })
            searchButtonState = !searchButtonState
        } else {
            UIView.animate(withDuration: 0.2, delay: 0,options: .curveEaseOut ,animations: {
                self.searchBar.alpha = 0.0
                self.searchBar.isUserInteractionEnabled = false
                self.searchBar.text = ""
            })
            searchButtonState = !searchButtonState
        }

    }

    private func configureUI() {

        view.addSubview(keepItMainLabel)
        keepItMainLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(25)
        }

        view.addSubview(searchBar)
        searchBar.alpha = 0.0
        searchBar.snp.makeConstraints {
            $0.top.equalTo(keepItMainLabel.snp.bottom).offset(10)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(view.bounds.width - 20)
        }

        view.addSubview(filterStackView)
        filterStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(25)
        }

        view.addSubview(mainToolBar)
        mainToolBar.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.height.equalTo(60)
        }

        view.addSubview(mainCollectionView)
        mainCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(10)
            $0.bottom.equalTo(mainToolBar.snp.top)
        }

        view.bringSubviewToFront(mainToolBar)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.cellId, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        cell.loadProduct(names[indexPath.row], product: product[indexPath.row], price: price[indexPath.row])
        cell.backgroundColor = UIColor.white
        return cell
    }
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height

        let itemsPerRow: CGFloat = 3
        let itemsPerCol: CGFloat = 3

        let widthPadding = sectionInset.left * (itemsPerRow+1)
        let heightPadding = sectionInset.top * (itemsPerCol+1)

        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight = (height - heightPadding) / itemsPerCol

        return CGSize(width: cellWidth, height: cellHeight)
    }
    */
}

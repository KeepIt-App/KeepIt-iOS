//
//  MainCollectionViewCell.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/11/12.
//

import UIKit
import SnapKit

class MainCollectionViewCell: UICollectionViewCell {

    static let cellId = "MainCell"

    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mac")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        
        return imageView
    }()

    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NanumSquareEB", size: 15)
        label.textColor = UIColor.defaultBlack
        label.text = "맥북 딱 대"
        return label
    }()

    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NanumSquareR", size: 13)
        label.textColor = UIColor.disabledAllGray
        label.text = "₩1,690,000원"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 0.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 1.5
        self.layer.shadowOpacity = 0.3
        self.layer.masksToBounds = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func loadProduct(_ name: String, product: String, price: String) {
        productImageView.image = UIImage(named: name)
        productNameLabel.text = product
        productPriceLabel.text = price
    }

    private func configureLayout() {

        addSubview(productPriceLabel)
        productPriceLabel.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.bottom).inset(10)
            $0.leading.equalTo(self.snp.leading).offset(15)
            //$0.height.equalTo(15)
        }

        addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints {
            $0.bottom.equalTo(productPriceLabel.snp.top).offset(-3)
            $0.leading.equalTo(self.snp.leading).offset(15)
            //$0.height.equalTo(30)
        }

        addSubview(productImageView)
        productImageView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
            $0.bottom.equalTo(productNameLabel.snp.top).offset(-10)
        }
    }
}

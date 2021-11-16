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
        imageView.image = UIImage(named: "Swift")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NanumSquareB", size: 20)
        label.textColor = UIColor.defaultBlack
        label.text = "서위퍼터 책"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        self.layer.cornerRadius = 8
        self.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(150)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLayout() {
        addSubview(productImageView)
        productImageView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
            $0.width.equalTo(80)
            $0.height.equalTo(100)
        }

        addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.bottom)
            $0.top.equalTo(productImageView.snp.bottom).offset(30)
            $0.leading.equalTo(self.snp.leading).offset(10)
        }
    }
}

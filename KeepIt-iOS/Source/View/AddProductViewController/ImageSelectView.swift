//
//  ImageSelectView.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/11/17.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class ImageSelectView: UIView {

    private let selectImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let selectButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.setTitle("이미지 추가", for: .normal)
        button.setTitleColor(UIColor.disabledGray, for: .normal)
        button.imageView?.tintColor = UIColor.disabledGray
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)

        return button
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .none
        configureLayout()
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.disabledGray.cgColor
        self.layer.cornerRadius = 16
    }

    private func configureLayout() {
        addSubview(selectButton)
        selectButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(self.snp.bottom)
        }
    }

    func loadSelectImage(image: UIImage) {
        selectButton.isHidden = true
        selectImageView.image = image
        addSubview(selectImageView)
        selectButton.removeFromSuperview()
        selectImageView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
            $0.height.equalTo(300)
        }
        self.layer.borderWidth = 0
    }
}

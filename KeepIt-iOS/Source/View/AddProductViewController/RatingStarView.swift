//
//  RatingStarView.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/11/18.
//

import UIKit

class RatingStarView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLayout() {
        var width: CGFloat = 0

        for star in 1...5 {
            let button = UIButton()
            button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill
            button.tintColor = UIColor.disabledGray
            button.tag = star
            button.addTarget(self, action: #selector(AddProductViewController.starButtonAction), for: .touchUpInside)
            addSubview(button)
            button.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(button.intrinsicContentSize.width).offset(width)
                $0.width.equalTo(45)
                $0.height.equalTo(40)
            }

            width += 45
        }
    }
}

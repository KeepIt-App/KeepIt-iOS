//
//  SaveSuccessView.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/12/10.
//

import UIKit
import SnapKit

class SaveSuccessView: UIView {

    private let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()

    private let successLabel: UILabel = {
        let label = UILabel()
        label.text = "아이템 등록이 완료되었습니다."
        label.font = UIFont(name: "NanumSquareB", size: 15)
        label.textColor = .white
        return label
    }()

    private lazy var successStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [checkImageView, successLabel])
        checkImageView.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }

        stackView.spacing = 10

        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func configureLayout() {
        self.backgroundColor = UIColor(red: 0.37, green: 0.59, blue: 0.34, alpha: 0.8)
        self.layer.cornerRadius = 30

        self.addSubview(successStackView)

        successStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }

}

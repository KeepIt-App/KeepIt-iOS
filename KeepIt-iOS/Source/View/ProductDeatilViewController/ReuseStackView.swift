//
//  ReuseStackView.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/12/12.
//

import UIKit
import SnapKit
import OpenGraph
import Kingfisher

class ReuseStackView: UIView {

    private let stackLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "link")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .keepItBlue
        return imageView
    }()

    private let productStackLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NanumSquareB", size: 15)
        label.text = "등록된 링크가 없습니다."
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

    private let openGraphTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NanumSquareEB", size: 15)
        label.textColor = UIColor.defaultBlack
        label.text = "불러오는중.."
        return label
    }()

    private let openGraphSubLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NanumSquareB", size: 15)
        label.textColor = UIColor.disabledAllGray
        label.text = "불러오는중.."
        return label
    }()

    private let openGraphImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var openGraphLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [openGraphTitleLabel, openGraphSubLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var openGraphAllStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [openGraphLabelStackView, openGraphImageView])
        stackView.axis = .horizontal
        openGraphImageView.snp.makeConstraints {
            $0.width.equalTo(75)
            $0.height.equalTo(75)
        }
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.isHidden = true
        return stackView
    }()

    let linkMoveButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.isHidden = true
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showOpenGraph() {
        openGraphAllStackView.isHidden = false
        linkMoveButton.isHidden = false
        reuseStackView.isHidden = true
    }

    func configureOpenGraphData(data: OpenGraph) {
        self.openGraphTitleLabel.text = data[.title]
        self.openGraphSubLabel.text = data[.description]
        guard let urlString = data[.image] else { return }
        let url = URL(string: urlString)
        self.openGraphImageView.kf.indicatorType = .activity
        self.openGraphImageView.kf.setImage(
            with: url,
            placeholder: nil,
            options: [.transition(.fade(0.4))],
            completionHandler: nil
        )
    }

    

    private func configureLayout() {
        addSubview(reuseStackView)
        addSubview(openGraphAllStackView)
        addSubview(linkMoveButton)
        reuseStackView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(15)
            $0.leading.equalTo(self.snp.leading)
        }

        openGraphAllStackView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
        }

        linkMoveButton.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
            $0.bottom.equalTo(self.snp.bottom)
        }

        self.bringSubviewToFront(linkMoveButton)

    }
}

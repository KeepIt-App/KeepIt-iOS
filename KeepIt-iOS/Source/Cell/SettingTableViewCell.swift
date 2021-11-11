//
//  SettingTableViewCell.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/11/11.
//

import UIKit
import SnapKit

class SettingTableViewCell: UITableViewCell {

    static let cellId = "SettingTableCell"

    private let cellMainLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont(name: "NanumSquareB", size: 16)

        return label
    }()

    private let cellSubLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray2
        label.font = UIFont(name: "NanumSquareB", size: 13)

        return label
    }()

    private lazy var cellStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cellMainLabel, cellSubLabel])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .leading

        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLabel(main: String, sub: String) {
        cellMainLabel.text = main
        cellSubLabel.text = sub
    }

    private func configureLayout() {
        addSubview(cellStackView)
        cellStackView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading).offset(20)
            $0.trailing.equalTo(self.snp.trailing)
            $0.bottom.equalTo(self.snp.bottom)
        }
    }

}

//
//  SportsTableViewCell.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 6.05.2025.
//

import UIKit
import RxCocoa
import RxSwift

final class SportsTableViewCell: BaseTableViewCell {
    
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContentView()
        applyStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContentView() {
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                            constant: Global.Constants.Constraints.defaultPadding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: Global.Constants.Constraints.defaultPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -Global.Constants.Constraints.defaultPadding),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                               constant: -Global.Constants.Constraints.defaultPadding)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func bind(withProtocol viewModel: BaseCellDataProtocol) {
        guard let model = viewModel as? SportsTableViewCellViewModel else {
            return
        }
        model.title.asObservable().bind(to: titleLabel.rx.text).disposed(by: disposeBag)
    }

    override func applyStyling() {
        super.applyStyling()
    }
}

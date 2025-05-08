//
//  CartTableViewCell.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 7.05.2025.
//

import UIKit
import RxCocoa
import RxSwift

final class CartTableViewCell: BaseTableViewCell {
    
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Global.Constants.Styling.textColor
        label.font = Global.Constants.Styling.font
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var teamsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Global.Constants.Styling.textColor
        label.font = Global.Constants.Styling.font
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var containerVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [teamsLabel,
                                                       titleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var currentItem: EventDetailOddsTableViewCellViewModel?
    private var odds: Odds?
    weak var delegate: EventDetailOddsTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContentView()
        applyStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContentView() {
        containerView.addSubview(containerVerticalStackView)
        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerVerticalStackView.topAnchor.constraint(equalTo: containerView.topAnchor,
                                                            constant: Global.Constants.Constraints.defaultPadding),
            containerVerticalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                                constant: Global.Constants.Constraints.defaultPadding),
            containerVerticalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                                 constant: -Global.Constants.Constraints.defaultPadding),
            containerVerticalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                                               constant: -Global.Constants.Constraints.defaultPadding),

            containerView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: Global.Constants.Constraints.defaultPadding),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: Global.Constants.Constraints.defaultPadding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -Global.Constants.Constraints.defaultPadding),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                  constant: -Global.Constants.Constraints.defaultPadding),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func bind(withProtocol viewModel: BaseCellDataProtocol) {
        guard let model = viewModel as? CartTableViewCellViewModel else {
            return
        }
        model.title.asObservable().bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        model.teams.asObservable().bind(to: teamsLabel.rx.text).disposed(by: disposeBag)
    }

    override func applyStyling() {
        super.applyStyling()
        containerView.layer.borderWidth = Global.Constants.Styling.borderWidth
        containerView.layer.borderColor = Global.Constants.Styling.borderColor.cgColor
        containerView.layer.cornerRadius = Global.Constants.Styling.cornerRadius
    }
}

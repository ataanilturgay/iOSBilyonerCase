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
    private let titleLabel = BetLabel()
    private let teamsLabel = BetLabel()
    
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
                                                            constant: BetStyling.Spacing.medium),
            containerVerticalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                                constant: BetStyling.Spacing.medium),
            containerVerticalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                                 constant: -BetStyling.Spacing.medium),
            containerVerticalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                                               constant: -BetStyling.Spacing.medium),

            containerView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: BetStyling.Spacing.medium),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: BetStyling.Spacing.medium),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -BetStyling.Spacing.medium),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                  constant: -BetStyling.Spacing.medium),
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

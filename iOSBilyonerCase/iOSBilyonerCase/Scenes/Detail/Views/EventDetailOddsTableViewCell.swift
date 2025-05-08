//
//  EventDetailOddsTableViewCell.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 6.05.2025.
//

import UIKit
import RxCocoa
import RxSwift

protocol EventDetailOddsTableViewCellDelegate: AnyObject {
    
    func didSelectOdds(cartItem: Cart)
}

final class EventDetailOddsTableViewCell: BaseTableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        
        enum CartButton {
            
            static let width: CGFloat = 100.0
            static let height: CGFloat = 40.0
        }
    }
    
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
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Global.Constants.addToCartText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = .primaryBackgroundColor
        button.layer.cornerRadius = Global.Constants.Styling.cornerRadius
        button.addTarget(self, action:  #selector(addToCartButtonTapped), for: .touchUpInside)
        return button
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
        containerView.addSubview(addToCartButton)
        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerVerticalStackView.topAnchor.constraint(equalTo: containerView.topAnchor,
                                                            constant: BetStyling.Spacing.medium),
            containerVerticalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                                constant: BetStyling.Spacing.medium),
            containerVerticalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                                               constant: -BetStyling.Spacing.medium),
            
            addToCartButton.leadingAnchor.constraint(equalTo: containerVerticalStackView.trailingAnchor,
                                                     constant: BetStyling.Spacing.medium),
            addToCartButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                      constant: -BetStyling.Spacing.medium),
            addToCartButton.centerYAnchor.constraint(equalTo: containerVerticalStackView.centerYAnchor),
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: BetStyling.Spacing.medium),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: BetStyling.Spacing.medium),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -BetStyling.Spacing.medium),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                  constant: -BetStyling.Spacing.medium),
            
            addToCartButton.widthAnchor.constraint(equalToConstant: Constants.CartButton.width),
            addToCartButton.heightAnchor.constraint(equalToConstant: Constants.CartButton.height)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func bind(withProtocol viewModel: BaseCellDataProtocol) {
        guard let model = viewModel as? EventDetailOddsTableViewCellViewModel else {
            return
        }
        self.currentItem = model
        self.odds = model.odds
        titleLabel.text = model.title
        teamsLabel.text = model.teams
    }

    override func applyStyling() {
        super.applyStyling()
        containerView.layer.borderWidth = Global.Constants.Styling.borderWidth
        containerView.layer.borderColor = Global.Constants.Styling.borderColor.cgColor
        containerView.layer.cornerRadius = Global.Constants.Styling.cornerRadius
    }
    
    @objc private func addToCartButtonTapped() {
        guard let item = currentItem else { return }
        let cartItem = Cart(id: item.odds.id,
                            title: item.title,
                            price: item.outcome.price,
                            point: item.outcome.point,
                            teams: item.teams)

        self.delegate?.didSelectOdds(cartItem: cartItem)
    }
}

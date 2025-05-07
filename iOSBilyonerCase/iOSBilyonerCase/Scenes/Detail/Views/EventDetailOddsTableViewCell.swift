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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var teamsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
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
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Kupona Ekle", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = .primaryBackgroundColor
        button.layer.cornerRadius = 8
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
            containerVerticalStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            containerVerticalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            containerVerticalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            
            addToCartButton.leadingAnchor.constraint(equalTo: containerVerticalStackView.trailingAnchor, constant: 16),
            addToCartButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            addToCartButton.centerYAnchor.constraint(equalTo: containerVerticalStackView.centerYAnchor),
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            addToCartButton.widthAnchor.constraint(equalToConstant: 100),
            addToCartButton.heightAnchor.constraint(equalToConstant: 40)
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
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.primaryBackgroundColor.cgColor
        containerView.layer.cornerRadius = 8
    }
    
    @objc private func addToCartButtonTapped() {
        guard let item = currentItem else { return }
        let cartItem = Cart(id: item.odds.id,
                            title: item.title,
                            price: item.outcome.price,
                            point: item.outcome.point,
                            teams: item.teams)

        print("Sepet butonuna tıklandı")
        self.delegate?.didSelectOdds(cartItem: cartItem)
    }
}

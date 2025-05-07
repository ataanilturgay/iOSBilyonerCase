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
            containerVerticalStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            containerVerticalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            containerVerticalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 16),
            containerVerticalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),

            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
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
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.primaryBackgroundColor.cgColor
        containerView.layer.cornerRadius = 8
    }
}

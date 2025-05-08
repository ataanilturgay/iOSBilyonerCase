//
//  EventsCollectionViewCell.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import UIKit
import RxCocoa
import RxSwift

final class EventsTableViewCell: BaseTableViewCell {
    
    private let titleLabel = BetLabel(fontSize: BetStyling.TextSize.subtitle.size)
    private let teamsLabel = BetLabel(fontSize: BetStyling.TextSize.subtitle.size)
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, teamsLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
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
        contentView.addSubview(containerStackView)

        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                    constant: BetStyling.Spacing.medium),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                        constant: BetStyling.Spacing.medium),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                         constant: -BetStyling.Spacing.medium),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                       constant: -BetStyling.Spacing.medium)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func bind(withProtocol viewModel: BaseCellDataProtocol) {
        guard let model = viewModel as? EventsTableViewCellViewModel else {
            return
        }
        model.title.asObservable().bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        model.teams.asObservable().bind(to: teamsLabel.rx.text).disposed(by: disposeBag)
    }

    override func applyStyling() {
        super.applyStyling()
    }
}

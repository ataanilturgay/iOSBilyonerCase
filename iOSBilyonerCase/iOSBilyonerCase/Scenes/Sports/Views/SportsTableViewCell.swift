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
    
    private let titleLabel = BetLabel(fontSize: BetStyling.TextSize.subtitle.size)
    
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
                                            constant: BetStyling.Spacing.medium),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: BetStyling.Spacing.medium),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -BetStyling.Spacing.medium),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                               constant: -BetStyling.Spacing.medium)
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

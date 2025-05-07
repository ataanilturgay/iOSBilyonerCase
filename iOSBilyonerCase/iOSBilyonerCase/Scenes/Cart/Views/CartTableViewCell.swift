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
    
    private enum Constants {
        
        enum Styling {
            
            enum Label {
             
                static let textColor: UIColor = .black
                static let font: UIFont = .systemFont(ofSize: 14)
            }
            
            enum View {
                
                static let cornerRadius: CGFloat = 8.0
                static let borderColor: UIColor = .primaryBackgroundColor
                static let borderWidth: CGFloat = 1.0
            }
        }
        
        enum Constraints {
            
            static let defaultPadding: CGFloat = 16
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Styling.Label.textColor
        label.font = Constants.Styling.Label.font
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var teamsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Styling.Label.textColor
        label.font = Constants.Styling.Label.font
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
                                                            constant: Constants.Constraints.defaultPadding),
            containerVerticalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                                constant: Constants.Constraints.defaultPadding),
            containerVerticalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                                 constant: -Constants.Constraints.defaultPadding),
            containerVerticalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                                               constant: -Constants.Constraints.defaultPadding),

            containerView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: Constants.Constraints.defaultPadding),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: Constants.Constraints.defaultPadding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -Constants.Constraints.defaultPadding),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                  constant: -Constants.Constraints.defaultPadding),
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
        containerView.layer.borderWidth = Constants.Styling.View.borderWidth
        containerView.layer.borderColor = Constants.Styling.View.borderColor.cgColor
        containerView.layer.cornerRadius = Constants.Styling.View.cornerRadius
    }
}

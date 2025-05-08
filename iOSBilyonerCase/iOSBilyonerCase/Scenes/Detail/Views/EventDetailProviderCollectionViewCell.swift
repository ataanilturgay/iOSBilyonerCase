//
//  EventDetailProviderCollectionViewCell.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 6.05.2025.
//

import UIKit

final class EventDetailProviderCollectionViewCell: BaseCollectionViewCell {
    
    private enum Constants {
        
        enum Constraints {
            
            static let padding: CGFloat = 8
        }
    }

    static let reuseIdentifier = "EventDetailProviderCollectionViewCell"
    
    // MARK: - UI Elements
    
    private let titleLabel = BetLabel(alignment: .center, numberOfLines: 1)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = Global.Constants.Styling.cornerRadius
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                            constant: Constants.Constraints.padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: Constants.Constraints.padding),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                               constant: -Constants.Constraints.padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -Constants.Constraints.padding)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(name: String, isSelected: Bool) {
        titleLabel.text = name
        contentView.backgroundColor = isSelected ? .primaryBackgroundColor : .lightGray
        titleLabel.textColor = .white
    }
}

//
//  CartButton.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 7.05.2025.
//

import UIKit

final class CartButton: UIButton {

    private lazy var badgeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .red
        label.font = .systemFont(ofSize: 8, weight: .bold)
        label.textAlignment = .center
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBadge()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBadge()
    }

    private func setupBadge() {
        addSubview(badgeLabel)

        NSLayoutConstraint.activate([
            badgeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: -8),
            badgeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 8),
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 14),
            badgeLabel.heightAnchor.constraint(equalToConstant: 14)
        ])
    }

    func setBadge(count: Int) {
        badgeLabel.isHidden = (count == 0)
        badgeLabel.text = "\(count)"
    }
}

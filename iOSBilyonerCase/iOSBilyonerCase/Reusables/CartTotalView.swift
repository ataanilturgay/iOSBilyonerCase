//
//  CartTotalView.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 7.05.2025.
//

import UIKit

struct CartTotalViewModel {
    
    let carTotal: Double
    let eventTitle: String
}

final class CartTotalView: BaseView {
    
    private var totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private var eventNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var containerVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [totalLabel,
                                                       eventNumberLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.backgroundColor = .primaryBackgroundColor
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    private func configureView() {
        addSubview(containerVerticalStackView)

        NSLayoutConstraint.activate([
            containerVerticalStackView.topAnchor.constraint(equalTo: self.topAnchor),
            containerVerticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerVerticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerVerticalStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configure(with cart: CartTotalViewModel) {
        totalLabel.text = "Toplam Oran: \(cart.carTotal)"
        eventNumberLabel.text = cart.eventTitle
    }
    
    override func applyStyling() {
        super.applyStyling()
    }
}

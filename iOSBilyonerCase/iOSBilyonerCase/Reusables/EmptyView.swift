//
//  EmptyView.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 8.05.2025.
//

import UIKit

enum EmptyTypes {
    
    case cart
    case detail
    case events
    
    var message: String {
        switch self {
        case .cart:
            return "Kupon Boş"
        case .detail:
            return "Etkinlik detayı bulunamadı"
        case .events:
            return "Etkinlik yok"
        }
    }
    
    var description: String {
        switch self {
        case .cart:
            return "Lütfene kupona etkinlik ekle :)"
        default:
            return ""
        }
    }
}

final class EmptyView: BaseView {
    
    private let emptyLabel = BetLabel(textColor: .white)
    private let descriptionLabel = BetLabel(textColor: .white)
    
    private lazy var containerVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emptyLabel,
                                                       descriptionLabel])
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
    
    func configure(with type: EmptyTypes) {
        emptyLabel.text = type.message
        descriptionLabel.text = type.description
    }
    
    override func applyStyling() {
        super.applyStyling()
        containerVerticalStackView.layer.cornerRadius = Global.Constants.Styling.cornerRadius
        containerVerticalStackView.layer.borderWidth = Global.Constants.Styling.borderWidth
        containerVerticalStackView.layer.borderColor = Global.Constants.Styling.borderColor.cgColor
    }
}

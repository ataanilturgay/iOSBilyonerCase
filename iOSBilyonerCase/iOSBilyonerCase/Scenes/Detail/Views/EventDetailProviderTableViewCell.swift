//
//  EventDetailProviderTableViewCell.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 6.05.2025.
//

import UIKit
import RxSwift
import RxCocoa

protocol EventDetailProviderDelegate: AnyObject {
    
    func didSelectBetProvider(index: Int)
}

final class EventDetailProviderTableViewCell: BaseTableViewCell {
    
    weak var delegate: EventDetailProviderDelegate?
    
    private var selectedIndex: Int = 0
    private var providerNames = [Bookmaker]()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerClassCell(type: EventDetailProviderCollectionViewCell.self)
        collectionView.backgroundColor = .white
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    private func configureViews() {
        contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func bind(withProtocol viewModel: BaseCellDataProtocol) {
        guard let model = viewModel as? EventDetailProviderTableViewCellViewModel else {
            return
        }
        providerNames = model.betProviders.value
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension EventDetailProviderTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return providerNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventDetailProviderCollectionViewCell.reuseIdentifier, for: indexPath) as? EventDetailProviderCollectionViewCell else { return UICollectionViewCell() }
        let betProvider = providerNames[indexPath.row]
        cell.configure(name: betProvider.title,
                       isSelected: indexPath.row == self.selectedIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.delegate?.didSelectBetProvider(index: indexPath.row)
        collectionView.reloadData()
    }
}

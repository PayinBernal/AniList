//
//  NetflixTableViewCell.swift
//  AniList
//
//  Created by Eduardo Bernal on 9/18/17.
//  Copyright © 2017 EEBR. All rights reserved.
//

import UIKit
import SDWebImage

protocol NetflixTableViewCellDelegate {
    func didSelectSerie(serie: Serie, cell: NetflixTableViewCell)
}

class NetflixTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var series = [Serie]()
    var delegate: NetflixTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension NetflixTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return series.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! NetflixCollectionViewCell
        let serie = series[indexPath.row]
        
        cell.titleLabel.text = serie.title
        cell.popularityLabel.text = "\(serie.popularity)"
        if let url = URL(string: serie.image) {
            cell.backgroundImageView.sd_setImage(with: url)
        }
        
        return cell
    }
}

extension NetflixTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectSerie(serie: series[indexPath.row], cell: self)
    }
    
}

extension NetflixTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentView.bounds.size.width * 0.8, height: contentView.bounds.size.height)
    }
    
}

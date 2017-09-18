//
//  DetailViewController.swift
//  AniList
//
//  Created by Eduardo Bernal on 9/18/17.
//  Copyright © 2017 EEBR. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import SDWebImage

class DetailViewController: UIViewController {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var episodesLabel: UILabel!
    @IBOutlet weak var charactersLabel: UILabel!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var charactersTableView: UITableView!
    @IBOutlet weak var charactersHeightConstraint: NSLayoutConstraint!
    
    var serie: Serie? {
        didSet {
            configureView()
            requestSerieDetail(serie: serie!)
            requestSerieCharacters(serie: serie!)
        }
    }
    
    var serieDetail: SerieDetail? {
        didSet {
            configureDetails()
        }
    }
    
    var characters = [Character]() {
        didSet {
            configureCharacters()
        }
    }

    func configureView() {
        if let serie = serie {
            title = serie.title
            if let url = URL(string: serie.image), let bannerImageView = bannerImageView {
                bannerImageView.sd_setImage(with: url)
            }
        }
    }
    
    func configureDetails() {
        if let serieDetail = serieDetail, let descriptionLabel = descriptionLabel {
            descriptionLabel.text = serieDetail.description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            if let youtubeId = serieDetail.youtubeId, let playerView = playerView {
                playerView.load(withVideoId: youtubeId)
            }
            if let episodesLabel = episodesLabel {
                episodesLabel.text = "\(serieDetail.episodes) episodes"
            }
        }
    }
    
    func configureCharacters() {
        charactersLabel.isHidden = false
        charactersHeightConstraint.constant = CGFloat(characters.count * 100)
        
        charactersTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func requestSerieDetail(serie: Serie) {
        Networking.requestSerie(serie: serie, success: { self.serieDetail = $0 }) { self.showAlertWithError(error: $0) }
    }
    
    private func requestSerieCharacters(serie: Serie) {
        Networking.requestSerieCharacters(serie: serie, success: { self.characters = $0 }) { self.showAlertWithError(error: $0) }
    }

    @IBAction func labelDidTap(_ sender: Any) {
        let sender = sender as! UITapGestureRecognizer
        if let label = sender.view as? UILabel {
            label.numberOfLines = label.numberOfLines == 0 ? 3 : 0
            UIView.animate(withDuration: 0.5) {
                label.superview?.layoutIfNeeded()
            }
        }
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath)
        let character = characters[indexPath.row]
        
        cell.textLabel?.text = "\(character.name) \(character.lastName)"
        cell.detailTextLabel?.text = character.role
        
        if let url = URL(string: character.image), let imageView = cell.imageView {
            imageView.sd_setImage(with: url, completed: { _ in cell.setNeedsLayout() })
        }
        
        return cell
    }
}

extension UIViewController {
    
    func showAlertWithError(error: Error) {
        let alertController = UIAlertController(title: "We're sorry", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Accept", style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
}

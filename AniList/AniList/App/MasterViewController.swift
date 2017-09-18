//
//  MasterViewController.swift
//  AniList
//
//  Created by Eduardo Bernal on 9/18/17.
//  Copyright © 2017 EEBR. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var seriesArray = SeriesCollection(series: [Serie]())


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        Networking.requestAuth(success: {
            Networking.browseSeries(success: { self.seriesArray = $0; self.tableView.reloadData() }, failure: { self.showAlertWithError(error: $0) })
        }) { _ in print("failure :(") }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            controller.serie = sender as? Serie
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
        UIView.animate(withDuration: 0.5) { () -> Void in
            self.splitViewController?.preferredDisplayMode = .primaryHidden
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (seriesArray.count) / 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NetflixTableViewCell
            
        let index = (indexPath.row * 5)
        let slice: Slice<SeriesCollection> = seriesArray[index...(index + 4)]
        
        cell.series = Array(slice)
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 3.5
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
}

extension MasterViewController: NetflixTableViewCellDelegate {
    func didSelectSerie(serie: Serie, cell: NetflixTableViewCell) {
        performSegue(withIdentifier: "showDetail", sender: serie)
    }
}

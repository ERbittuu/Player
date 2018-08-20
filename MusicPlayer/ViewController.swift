//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Sanjay Shah on 14/08/18.
//  Copyright © 2018 Solution Analysts. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var playlist: Playlist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPlaylistFromLocal()
        tableView.reloadData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromPlaylistVCToMusicPlayerVC" {
            let destController = segue.destination as! MusicPlayerVC
            destController.song =  playlist.playlist[tableView.indexPathForSelectedRow!.row]
            destController.index = sender as! Int
        }
    }
}

extension ViewController {
    func getPlaylistFromLocal() {
        if let path = Bundle.main.path(forResource: "Sample", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, Any> {
                    playlist = Playlist(fromJson: JSON(jsonResult))
                }
            } catch {
                // handle error
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist!.playlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = playlist.playlist[indexPath.row].name
        
        cell.selectionStyle = .none
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueFromPlaylistVCToMusicPlayerVC", sender: indexPath.row)
    }
}

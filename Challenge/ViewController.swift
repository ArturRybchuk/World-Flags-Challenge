//
//  ViewController.swift
//  Challenge
//
//  Created by Artur Rybchuk on 3/27/26.
//

import UIKit

class ViewController: UITableViewController {
    
    // Data source: a simple list of all flag filenames found in the app
    var pictures = [String]()
    
    // Storage for mapping country codes to full names (e.g., "US" -> "United States")
    var countriesDictionary: [String:String] = [:]
   
    let buttonImg = UIImage(systemName: "gamecontroller.fill")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation UI setup
        title = "Flags"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // 1. JSON Data Loading
        // We find, load, and decode the JSON file into our dictionary
        if let url = Bundle.main.url(forResource: "Countries", withExtension: "json") {
            if let data = try? Data(contentsOf: url) {
                let decoder = JSONDecoder()
                if let decodedCountries = try? decoder.decode([String: String].self, from: data) {
                    self.countriesDictionary = decodedCountries
                }
            }
        }
        
        // 2. Resource Scanning
        // FileManager looks through the app folder to find all .png files
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        // Filter out everything except images and sort them alphabetically
        pictures = items.filter { $0.hasSuffix("png") }.sorted()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: buttonImg, style: .plain, target: self, action: #selector(gamePlay))
    }
    
    // MARK: - Helper Methods
        private func getCountryName(from filename: String) -> String {
            let shortName = filename.replacingOccurrences(of: ".png", with: "").uppercased()
            return countriesDictionary[shortName] ?? shortName
        }
    
    // MARK: - TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Reuse an existing cell to save memory
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        
        let imageName = pictures[indexPath.row]
        let originalImage = UIImage(named: imageName)
        
        // 3. Image Normalization
        // We force every flag to be exactly 40x30 points for a consistent UI
        let itemSize = CGSize(width: 40, height: 30)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, traitCollection.displayScale)
        
        let imageRect = CGRect(origin: .zero, size: itemSize)
        originalImage?.draw(in: imageRect)
        
        cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Apply visual styling (border and rounded corners) to the flag icon
        cell.imageView?.layer.cornerRadius = 4
        cell.imageView?.layer.masksToBounds = true
        cell.imageView?.layer.borderWidth = 0.5
        cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        
        // 4. Name installing
        cell.textLabel?.text = getCountryName(from: imageName)
        
        return cell
    }
    
    // 5. Navigation Logic
    // This runs when a user taps a row in the table
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Try to create the Detail screen from the Storyboard
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
                let imageName = pictures[indexPath.row]

                vc.selectedImage = imageName
                vc.countryName = getCountryName(from: imageName)
            
            // Smoothly push the new screen onto the navigation stack
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func gamePlay() {
        if let vc = storyboard?.instantiateViewController(identifier: "Game") as? GameViewController {
            vc.countriesDictionary = self.countriesDictionary
            vc.countries = Array(countriesDictionary.keys).map {$0.lowercased()}
            
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

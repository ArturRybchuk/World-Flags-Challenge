//
//  ViewController.swift
//  Challenge
//
//  Created by Artur Rybchuk on 3/27/26.
//

import UIKit

/// Main controller responsible for displaying the list of countries and coordinating navigation.
class ViewController: UITableViewController {
    
    // MARK: - Properties
    
    /// Data source: list of flag image filenames discovered in the app bundle.
    var pictures = [String]()
    
    /// Storage for mapping country ISO codes to full readable names (e.g., "US" -> "United States").
    var countriesDictionary: [String: String] = [:]
    
    /// System icon for the game navigation button.
    let buttonImg = UIImage(systemName: "gamecontroller.fill")!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationUI()
        loadCountryData()
        scanForFlagResources()
        
        // Setup the right bar button to trigger the game module
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: buttonImg,
            style: .plain,
            target: self,
            action: #selector(gamePlay)
        )
    }
    
    // MARK: - Setup Methods
    
    private func setupNavigationUI() {
        title = "Flags"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    /// 1. JSON Data Loading: Decodes the local Countries.json into the dictionary.
    private func loadCountryData() {
        if let url = Bundle.main.url(forResource: "Countries", withExtension: "json") {
            if let data = try? Data(contentsOf: url) {
                let decoder = JSONDecoder()
                if let decodedCountries = try? decoder.decode([String: String].self, from: data) {
                    self.countriesDictionary = decodedCountries
                }
            }
        }
    }
    
    /// 2. Resource Scanning: Dynamically finds all flag images in the bundle.
    private func scanForFlagResources() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        
        // Retrieve all files from the bundle and filter for PNG images
        if let items = try? fm.contentsOfDirectory(atPath: path) {
            pictures = items.filter { $0.hasSuffix("png") }.sorted()
        }
    }
    
    // MARK: - Helper Methods
    
    /// Converts a filename (e.g., "us.png") into a full country name using the dictionary.
    private func getCountryName(from filename: String) -> String {
        let shortName = filename.replacingOccurrences(of: ".png", with: "").uppercased()
        return countriesDictionary[shortName] ?? shortName
    }
    
    // MARK: - TableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Reuse an existing cell to optimize memory usage
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        
        let imageName = pictures[indexPath.row]
        let originalImage = UIImage(named: imageName)
        
        // 3. Image Normalization: Ensuring all flags have identical dimensions in the list.
        let itemSize = CGSize(width: 40, height: 30)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, traitCollection.displayScale)
        
        let imageRect = CGRect(origin: .zero, size: itemSize)
        originalImage?.draw(in: imageRect)
        
        cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Apply consistent visual styling to the flag icon
        cell.imageView?.layer.cornerRadius = 4
        cell.imageView?.layer.masksToBounds = true
        cell.imageView?.layer.borderWidth = 0.5
        cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        
        // 4. Data Binding: Assigning the full country name to the label
        cell.textLabel?.text = getCountryName(from: imageName)
        
        return cell
    }
    
    // MARK: - Navigation Logic
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 5. Detail Navigation: Pushes the selected flag to the Detail screen
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            let imageName = pictures[indexPath.row]
            
            vc.selectedImage = imageName
            vc.countryName = getCountryName(from: imageName)
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    /// Transition to the Quiz module (GameViewController)
    @objc func gamePlay() {
        if let vc = storyboard?.instantiateViewController(identifier: "Game") as? GameViewController {
            vc.countriesDictionary = self.countriesDictionary
            vc.countries = Array(countriesDictionary.keys).map { $0.lowercased() }
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

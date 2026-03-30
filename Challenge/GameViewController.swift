//
//  GameViewController.swift
//  Challenge
//
//  Created by Artur Rybchuk on 3/28/26.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var buttonOne: UIButton!
    @IBOutlet var buttonTwo: UIButton!
    @IBOutlet var buttonThree: UIButton!
    @IBOutlet var buttonCollection: [UIButton]!
    
    var countries = [String]()
    var countriesDictionary = [String: String]()
    var currentCountryFullName = ""
    var scores = 0
    var correctAnswer = 0
    var counter = 0
    var countOfTheQuestions = 0
    
    let rightBarImg = UIImage(systemName: "info")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        countOfTheQuestions = countries.count
        
        askQuestion()
        setupButtonStyle()
        
        print(countries)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    func askQuestion(action: UIAlertAction? = nil) {
        
        countries.shuffle()
        correctAnswer = .random(in: 0...2)
        
        buttonOne.setImage(UIImage(named: countries[0]), for: .normal)
        buttonTwo.setImage(UIImage(named: countries[1]), for: .normal)
        buttonThree.setImage(UIImage(named: countries[2]), for: .normal)
        
        let codeToFind = countries[correctAnswer].uppercased()
        currentCountryFullName = countriesDictionary[codeToFind] ?? codeToFind
        
        title = "Guess the flag of: \(currentCountryFullName)"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarImg, style: .plain, target: self, action: #selector(infoBtnTapped))
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        Style.animateSelectionBounce(for: sender)
        
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct!"
            scores += 1
        } else {
            title = "Wrong! That's the flag of \(countriesDictionary[countries[sender.tag].uppercased()] ?? countries[sender.tag])"
        }
        counter += 1
        
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        if counter == countOfTheQuestions {
            ac.title = "Game Over"
            ac.message = "Your final score is \(scores)"
            ac.addAction(UIAlertAction(title: "Play Again", style: .destructive) { [weak self] _ in
                self?.scores = 0
                self?.counter = 0
                self?.askQuestion()
            })
        } else {
            ac.message = "Your current score is \(scores)"
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        }
        present(ac, animated: true)
    }
    
    func setupButtonStyle() {
        if let buttonCollection = buttonCollection {
            for button in buttonCollection {
                Style.buttonStyle(for: button, borderWidth: 1, borderColor: .lightGray)

            }
        }
    }
    
    
    @objc func infoBtnTapped() {
        
        let message = """
            Guess the flag of \(currentCountryFullName)
            Question: \(counter) of \(countOfTheQuestions)
            Current Score: \(scores)
            """
        let ac = UIAlertController(title: "Game info", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Got it", style: .default))
        present(ac, animated: true)
    }
    
}

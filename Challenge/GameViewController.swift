//
//  GameViewController.swift
//  Challenge
//
//  Created by Artur Rybchuk on 3/28/26.
//

import UIKit

/// Controller managing the quiz logic, score tracking, and interactive feedback.
class GameViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var buttonOne: UIButton!
    @IBOutlet var buttonTwo: UIButton!
    @IBOutlet var buttonThree: UIButton!
    @IBOutlet var buttonCollection: [UIButton]!
    
    // MARK: - Properties
    
    /// List of available country ISO codes for the quiz.
    var countries = [String]()
    
    /// Reference dictionary for mapping codes to full names.
    var countriesDictionary = [String: String]()
    
    /// The name of the country the user needs to find.
    var currentCountryFullName = ""
    
    var scores = 0
    var correctAnswer = 0
    var counter = 0
    var countOfTheQuestions = 0
    
    let rightBarImg = UIImage(systemName: "info")!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        countOfTheQuestions = countries.count
        
        setupButtonStyle()
        askQuestion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure bars are visible in game mode
        navigationController?.hidesBarsOnTap = false
    }
    
    // MARK: - Game Logic
    
    /// Core game loop: shuffles data and updates the UI for a new round.
    func askQuestion(action: UIAlertAction? = nil) {
        // Shuffle the deck to ensure random flag distribution
        countries.shuffle()
        
        // Randomly pick which of the first 3 buttons will hold the correct answer
        correctAnswer = .random(in: 0...2)
        
        // Update button images with the new shuffled set
        buttonOne.setImage(UIImage(named: countries[0]), for: .normal)
        buttonTwo.setImage(UIImage(named: countries[1]), for: .normal)
        buttonThree.setImage(UIImage(named: countries[2]), for: .normal)
        
        // Resolve the full country name for the current round
        let codeToFind = countries[correctAnswer].uppercased()
        currentCountryFullName = countriesDictionary[codeToFind] ?? codeToFind
        
        title = "Find: \(currentCountryFullName)"
        
        // Refresh the info button in the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: rightBarImg,
            style: .plain,
            target: self,
            action: #selector(infoBtnTapped)
        )
    }
    
    // MARK: - Actions
    
    /// Handles flag selection, triggers feedback animations, and processes scoring.
    @IBAction func buttonPressed(_ sender: UIButton) {
        // UI Feedback: Visual bounce animation on tap (from Style utility)
        Style.animateSelectionBounce(for: sender)
        
        var alertTitle: String
        
        // Scoring logic check
        if sender.tag == correctAnswer {
            alertTitle = "Correct!"
            scores += 1
        } else {
            // Contextual feedback: show the user the name of the flag they actually tapped
            let tappedCountry = countriesDictionary[countries[sender.tag].uppercased()] ?? countries[sender.tag]
            alertTitle = "Wrong! That's the flag of \(tappedCountry)"
        }
        counter += 1
        
        let ac = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        
        // Handle Game Completion
        if counter == countOfTheQuestions {
            ac.title = "Game Over"
            ac.message = "Your final score is \(scores)"
            ac.addAction(UIAlertAction(title: "Play Again", style: .destructive) { [weak self] _ in
                self?.scores = 0
                self?.counter = 0
                self?.askQuestion()
            })
        } else {
            // Continue the session
            ac.message = "Your current score is \(scores)"
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        }
        
        present(ac, animated: true)
    }
    
    // MARK: - UI Configuration
    
    /// Iterates through the button collection to apply consistent styling via the Style utility.
    func setupButtonStyle() {
        if let buttonCollection = buttonCollection {
            for button in buttonCollection {
                Style.buttonStyle(for: button, borderWidth: 1, borderColor: .lightGray)
            }
        }
    }
    
    // MARK: - Utilities
    
    /// Displays a summary of the current game progress to the user.
    @objc func infoBtnTapped() {
        let message = """
            Find the flag of: \(currentCountryFullName)
            Question: \(counter) of \(countOfTheQuestions)
            Current Score: \(scores)
            """
        let ac = UIAlertController(title: "Game Status", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Got it", style: .default))
        present(ac, animated: true)
    }
}

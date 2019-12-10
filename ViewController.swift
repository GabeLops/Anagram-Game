//
//  ViewController.swift
//  Project5
//
//  Created by Gabriel Lops on 12/2/19.
//  Copyright © 2019 Gabriel Lops. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkwork"]
        }
        startGame()
    }
    
    @objc func startGame () {
        let ac = UIAlertController(title: "New Game", message: "Try to make as many Anagrams as possible", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default))
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
        present(ac, animated: true)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    func submit (_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer){
            if isOriginal(word: lowerAnswer){
                if isReal(word: lowerAnswer){
                    usedWords.insert(answer.lowercased(), at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                }else{
                    showErrorMessage(error: answer)
                        
                    
                    
                }
            }else {
                showErrorMessage(error: answer)
                
            }
        }else {
            showErrorMessage(error: answer)
            
            
        }

        
        
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else{ return false }
      
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
                
            }else {
                return false
            }
        }
        return true
        
    }
    
    func isOriginal (word: String) -> Bool {
        if word == title {return false}
        return !usedWords.contains(word.lowercased())
    }
    
    func isReal(word: String) -> Bool {
        if word.count < 3 {
            return false
        }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func showErrorMessage(error: String){
        var errorTitle: String
        var errorMessage: String
        
        if !isReal(word: error){
            
        errorTitle = "Word not recognized or under 3 letters"
        errorMessage = "Don't make it up, have more than 2 letter words"
            
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default))
        present (ac, animated: true)
            
        } else if !isOriginal(word: error){
            
        errorTitle = "Word already used"
        errorMessage = "Be more origninal"
            
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default))
        present (ac, animated: true)
            
        }else if !isPossible(word: error){
            
        errorTitle = "Word not possible"
        errorMessage = "You can't spell that word from \(title!.lowercased())."
            
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default))
        present (ac, animated: true)
        }
       

       
       
        }
    
    

}


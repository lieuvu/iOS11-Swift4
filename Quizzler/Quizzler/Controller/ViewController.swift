//
//  ViewController.swift
//  Quizzler
//

import UIKit


class ViewController: UIViewController {
    
    // MARK: Outlets
    // **********************************************************************
    
    /// The question label.
    @IBOutlet private weak var questionLabel: UILabel!
    
    /// The score label.
    @IBOutlet private weak var scoreLabel: UILabel!
    
    /// The progress label.
    @IBOutlet private weak var progressLabel: UILabel!
    
    /// The progress bar.
    @IBOutlet private weak var progressBar: UIView!
    
    // MARK: Properties
    // **********************************************************************
    
    /// The all questions.
    private let allQuestions = QuestionBank()
    
    /// The question number. It will observe the change when a question number
    /// reaches the maximum number in the bank.
    private var questionNumber: Int = 0 {
        didSet {
            if questionNumber == allQuestions.questions.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    let alert = UIAlertController(title: "Awesome", message: "You've finished all the questions, do you want to start over?", preferredStyle: .alert)
                    let restartAction = UIAlertAction(title: "Restart", style: .default) { (UIAlertAction) in self.startOver() }
                    alert.addAction(restartAction)
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                self.nextQuestion()
            }
            
        }
    }
    
    /// The score number.
    private var score = 0
    
    // MARK: Life Cycle
    // **********************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextQuestion()
    }
    
    // MARK: Actions
    // **********************************************************************
    
    @IBAction private func answerPressed(_ sender: AnyObject) {
        var pickedAnswer: Bool = false
        
        if sender.tag == 1 {
            pickedAnswer = true
        }
        
        checkAnswer(pickedAnswer)
        questionNumber += 1
    }
    
    
    // MARK: Others
    // **********************************************************************
    
    private func updateProgressUI() {
        scoreLabel.text = "Score: \(score)"
        progressLabel.text = "\(questionNumber + 1) / \(allQuestions.questions.count)"
        progressBar.frame.size.width = view.frame.size.width / CGFloat(allQuestions.questions.count) * CGFloat(questionNumber + 1)
    }
    

    private func nextQuestion() {
        questionLabel.text = allQuestions.questions[questionNumber].questionText
        updateProgressUI()
    }
    
    private func checkAnswer(_ answer:Bool) {
        if answer == allQuestions.questions[questionNumber].answer {
            ProgressHUD.showSuccess("Correct")
            score += 1
        } else {
            ProgressHUD.showError("Wrong!")
        }
    }
    
    private func startOver() {
        score = 0
        questionNumber = 0
    }

}

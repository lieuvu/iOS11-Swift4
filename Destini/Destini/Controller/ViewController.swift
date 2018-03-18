//
//  ViewController.swift
//  Destini
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Outlets
    // **********************************************************************
    
    /// The restart button.
    @IBOutlet private weak var restartButton: UIButton!
    
    /// The text view to show story.
    @IBOutlet private weak var storyTextView: UILabel!
    
    /// The top button.
    @IBOutlet private weak var topButton: UIButton!         // Has TAG = 1
    
    /// The bottom button.
    @IBOutlet private weak var bottomButton: UIButton!      // Has TAG = 2
    
    // MARK: Properties
    // **********************************************************************
    
    /// The wrapper of constant.
    private enum Constant {
        static let ROOT_STORY: Story = StoryStructure().rootStory
    }
    
    /// The current story.
    private var currentStory: Story!
    
    // MARK: Life Cycle
    // **********************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentStory = Constant.ROOT_STORY
        restartButton.isHidden = true
        storyTextView.text = Constant.ROOT_STORY.story
        topButton.setTitle(Constant.ROOT_STORY.answers?.a.getAnswer(), for: .normal)
        bottomButton.setTitle(Constant.ROOT_STORY.answers?.b.getAnswer(), for: .normal)
    }

    // MARK: Actions
    // **********************************************************************
    
    /// Press top button or bottom button.
    ///
    /// - Parameters:
    ///     - sender: The top button or bottom button. The top button has
    ///               tag that equals 1 and the bottom button has tag that
    ///               equals 2.
    @IBAction private func buttonPressed(_ sender: UIButton) {
        // if select answer a.
        if sender.tag == 1 {
            currentStory = currentStory.answers?.a.getStory()
            // otherwise, select answer b.
        } else {
            currentStory = currentStory.answers?.b.getStory()
        }
        
        nextStory()
    }
    
    /// Press restart button.
    @IBAction  private func restart() {
        currentStory = Constant.ROOT_STORY
        storyTextView.text = currentStory.story
        topButton.setTitle(currentStory.answers?.a.getAnswer(), for: .normal)
        bottomButton.setTitle(currentStory.answers?.b.getAnswer(), for: .normal)
        topButton.isHidden = false
        bottomButton.isHidden = false
        restartButton.isHidden = true
    }
    
    // MARK: Others
    // **********************************************************************
    
    /// Show the next story.
    private func nextStory() {
        restartButton.isHidden = false
        storyTextView.text = currentStory.story
        
        if let answers = currentStory.answers {
            topButton.setTitle(answers.a.getAnswer(), for: .normal)
            bottomButton.setTitle(answers.b.getAnswer(), for: .normal)
        } else {
            topButton.isHidden = true
            bottomButton.isHidden = true
        }
    }
}


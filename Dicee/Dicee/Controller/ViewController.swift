//
//  ViewController.swift
//  Dicee
//
//  Created by Lieu Vu on 1/8/18.
//  Copyright © 2018 Lieu Vu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Outlets
    // **********************************************************************
    
    /// The image of dice 1.
    @IBOutlet weak var diceImageView1: UIImageView!
    
    /// The image of dice 2.
    @IBOutlet weak var diceImageView2: UIImageView!
    
    // MARK: Properties
    // **********************************************************************
    
    /// The random index of dice 1.
    private var randomDiceIndex1: Int = 0
    
    /// The random index of dice 2.
    private var randomDiceIndex2: Int = 0
    
    /// The max faces of a dice.
    private let maxFacesOfADice: UInt32 = 6
    
    // MARK: Life Cycle
    // **********************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDiceImages()
    }

    // MARK: Actions
    // **********************************************************************
    
    @IBAction private func rollButtonPress(_ sender: UIButton) {
        updateDiceImages()
    }
    
    // MARK: Motions
    // **********************************************************************
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            updateDiceImages()
        }
    }
    
    // MARK: Others
    // **********************************************************************
    
    private func updateDiceImages() {
        randomDiceIndex1 = Int(arc4random_uniform(maxFacesOfADice)) + 1
        randomDiceIndex2 = Int(arc4random_uniform(maxFacesOfADice)) + 1
        diceImageView1.image = UIImage(named: "dice\(randomDiceIndex1)")
        diceImageView2.image = UIImage(named: "dice\(randomDiceIndex2)")
    }
}


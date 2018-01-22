//
//  ViewController.swift
//  Magic 8 Ball
//
//  Created by Lieu Vu on 1/8/18.
//  Copyright © 2018 Lieu Vu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Outlets
    // **********************************************************************
    
    /// The image view.
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: Properties
    // **********************************************************************
    
    /// The random ball number.
    private var randomBallNumber = 0
    
    /// The max number of ball.
    private let maxNumberOfBall: UInt32 = 5
    
    // MARK: Life Cycle
    // **********************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newBallImage()
    }

    // MARK: Actions
    // **********************************************************************

    @IBAction func askButtonPress(_ sender: UIButton) {
        newBallImage()
    }
    
    // MARK: Motions
    // **********************************************************************
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            newBallImage()
        }
    }
    
    // MARK: Others
    // **********************************************************************
    
    private func newBallImage() {
        randomBallNumber = Int(arc4random_uniform(maxNumberOfBall)) + 1
        imageView.image = UIImage(named: "ball\(randomBallNumber)")
    }
}


//
//  BattleViewController.swift
//  Pokémon Go
//
//  Created by Tejas on 07/04/17.
//  Copyright © 2017 Tejas-Nanaware. All rights reserved.
//

import UIKit
import SpriteKit
class BattleViewController: UIViewController {
    
    var pokemon : Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let battlescene = BattleScene(size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
        battlescene.pokemon = pokemon
        self.view = SKView()
        let mySKView = self.view as! SKView
        mySKView.showsFPS = false
        mySKView.showsNodeCount = false
        mySKView.ignoresSiblingOrder = false
        mySKView.presentScene(battlescene)
        battlescene.scaleMode = .aspectFit
        
        NotificationCenter.default.addObserver(self, selector: #selector(returnToMapView), name: NSNotification.Name("CloseBattle"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    func returnToMapView() {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

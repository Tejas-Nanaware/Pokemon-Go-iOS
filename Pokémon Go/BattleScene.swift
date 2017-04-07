//
//  BattleScene.swift
//  Pokémon Go
//
//  Created by Tejas on 07/04/17.
//  Copyright © 2017 Tejas-Nanaware. All rights reserved.
//

import UIKit
import SpriteKit

class BattleScene : SKScene, SKPhysicsContactDelegate {
    var pokemon : Pokemon!
    var pokemonSprite : SKSpriteNode!
    var pokeballSprite : SKSpriteNode!
    
    //define constants
    let kPokemonSize = CGSize(width: 100, height: 100)
    let kPokeballSize = CGSize(width: 50, height: 50)
    
    //define bitcategories
    let kPokeballCategory : UInt32 = 0x1 << 0
    let kPokemonCategory : UInt32 = 0x1 << 1
    let kEdgeCategory : UInt32 = 0x1 << 2
    
    //Physics Variables
    var velocity : CGPoint = CGPoint.zero
    var touchPoint : CGPoint = CGPoint()
    var canThrowPokeball : Bool = false
    
    //Other Variables
    var startCount = false
    var maxTime = 20
    var myTime = 20
    var pokemonCaught = false
    var timeLabel = SKLabelNode(fontNamed: "Helvetica")
    
    override func didMove(to view: SKView) {
        
        //Display Background
        let battleBG = SKSpriteNode(imageNamed: "bggg")
        battleBG.size = self.size
        battleBG.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        battleBG.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        battleBG.zPosition = -1
        self.addChild(battleBG)
        
        self.makeMessageWith(imageName: "battle")
        //Add Pokemon on screen
        self.perform(#selector(setupPokemon), with: nil, afterDelay: 1.5)
        self.perform(#selector(setupPokeball), with: nil, afterDelay: 2.0)
        
        //Frame Physics
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = kEdgeCategory
        
        //TimeLabel
        self.timeLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.9)
        self.addChild(timeLabel)
        
        self.physicsWorld.contactDelegate = self
        
        self.startCount = true
        
    }
    
    func setupPokemon() {
        
        //Init Pokemon
        self.pokemonSprite = SKSpriteNode(imageNamed: pokemon.imageFileName!)
        self.pokemonSprite.size = kPokemonSize
        self.pokemonSprite.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.pokemonSprite.zPosition = 0
        
        //Add Physics
        self.pokemonSprite.physicsBody = SKPhysicsBody(rectangleOf: kPokemonSize)
        self.pokemonSprite.physicsBody?.isDynamic = false
        self.pokemonSprite.physicsBody?.affectedByGravity = false
        self.pokemonSprite.physicsBody?.mass = 5.0
        
        //Moving the Pokemon
        let moveRight = SKAction.moveBy(x: self.size.width*0.3, y: 0, duration: 3.0)
        let sequence = SKAction.sequence([moveRight,moveRight.reversed(),moveRight.reversed(),moveRight])
        self.pokemonSprite.run(SKAction.repeatForever(sequence))
        
        //Bitmasks
        self.pokemonSprite.physicsBody?.categoryBitMask = kPokemonCategory
        self.pokemonSprite.physicsBody?.collisionBitMask = kEdgeCategory
        self.pokemonSprite.physicsBody?.contactTestBitMask = kPokeballCategory
        
        self.addChild(pokemonSprite)
        

    }
    
    func setupPokeball() {
        
        //Init Pokeball
        self.pokeballSprite = SKSpriteNode(imageNamed: "mega-ball")
        self.pokeballSprite.size = kPokeballSize
        self.pokeballSprite.position = CGPoint(x: self.size.width/2, y: self.size.height*0.1)
        self.pokeballSprite.zPosition = 0
        
        //Add Physics
        self.pokeballSprite.physicsBody = SKPhysicsBody(circleOfRadius: self.pokeballSprite.frame.size.width/2)
        self.pokeballSprite.physicsBody?.affectedByGravity = true
        self.pokeballSprite.physicsBody?.isDynamic = true
        self.pokeballSprite.physicsBody?.mass = 0.5
        
        //bitmasks
        self.pokeballSprite.physicsBody?.categoryBitMask = kPokeballCategory
        self.pokeballSprite.physicsBody?.collisionBitMask = kEdgeCategory | kPokemonCategory
        self.pokeballSprite.physicsBody?.contactTestBitMask = kPokemonCategory
        
        self.addChild(pokeballSprite)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let location = touch?.location(in: self)
        
        if self.pokeballSprite.frame.contains(location!) {
            self.canThrowPokeball = true
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let location = touch?.location(in: self)
        self.touchPoint = location!
        if self.canThrowPokeball {
            throwPokeball()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
        case kPokemonCategory | kPokeballCategory:
            print("caught")
            self.pokemonCaught = true
            endGame()
        default:
            return
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if self.startCount{
            self.maxTime = Int(currentTime) + self.maxTime
            self.startCount = false
        }
        self.myTime = self.maxTime - Int(currentTime)
        self.timeLabel.text = "\(self.myTime)"
        if self.myTime <= 0 {
            endGame()
        }
    }
    
    func throwPokeball() -> Void {
        self.canThrowPokeball = false
        let dt : CGFloat = 1.0/5         // 1second / frame
        let dist = CGVector(dx: self.touchPoint.x - self.pokeballSprite.position.x, dy: self.touchPoint.y - self.pokeballSprite.position.y)
        let velocity = CGVector(dx: dist.dx/dt, dy: dist.dy/dt)
        self.pokeballSprite.physicsBody?.velocity = velocity
    }
    
    func endGame() -> Void {
        self.pokeballSprite.removeFromParent()
        self.pokemonSprite.removeFromParent()
        
        if pokemonCaught {
            self.makeMessageWith(imageName: "gotcha")
            self.pokemon.caught += 1
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        } else {
            self.makeMessageWith(imageName: "footprints")
        }
        self.perform(#selector(endBattle), with: nil, afterDelay: 3.5)
    }
    
    func endBattle() -> Void {
        NotificationCenter.default.post(name: NSNotification.Name("CloseBattle"), object: nil)
    }
    
    func makeMessageWith(imageName : String){
        let message = SKSpriteNode(imageNamed: imageName)
        message.size = CGSize(width: 150, height: 150)
        message.position = CGPoint(x: self.size.width/2, y: self.size.height*0.3)
        message.zPosition = 0
        message.run(SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.removeFromParent()]))
        self.addChild(message)
    }
}

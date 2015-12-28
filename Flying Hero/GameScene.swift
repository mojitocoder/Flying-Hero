//
//  GameScene.swift
//  Flying Hero
//
//  Created by Quynh Nguyen on 24/12/2015.
//  Copyright (c) 2015 Quynh Nguyen. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var backgroundNode: SKSpriteNode?
    var playerNode: SKSpriteNode?
    var foregroundNode: SKSpriteNode?
    var orbNode: SKSpriteNode?
    
    var ImpulseCount: Int = 5
    
    let CollisionCategoryPlayer: UInt32 = 0x1 << 1
    let CollisionCategoryPowerUpOrbs: UInt32 = 0x1 << 2
    
    let PowerUpNodeName: String = "PowerUpNode"
    
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }

    override init(size: CGSize){
        
        super.init(size: size)
        
        physicsWorld.contactDelegate = self
        
        //Custom gravity for this game
        physicsWorld.gravity = CGVectorMake(0.0, -1.0)
        userInteractionEnabled = true
        backgroundColor  = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        //adding background node
        backgroundNode = SKSpriteNode(imageNamed: "Background")
        backgroundNode!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundNode!.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        addChild(backgroundNode!)
        
        //foreground
        foregroundNode = SKSpriteNode()
        addChild(foregroundNode!)
        
        //add player node
        playerNode = SKSpriteNode(imageNamed: "Player")
        playerNode!.physicsBody = SKPhysicsBody(circleOfRadius: playerNode!.size.width / 2)

        playerNode!.physicsBody!.dynamic = false
        playerNode!.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0 - 200)
        
        playerNode!.physicsBody!.linearDamping = 1.0
        playerNode!.physicsBody!.allowsRotation = false
        playerNode!.physicsBody!.categoryBitMask = CollisionCategoryPlayer
        playerNode!.physicsBody!.contactTestBitMask = CollisionCategoryPowerUpOrbs
        playerNode!.physicsBody!.collisionBitMask = 0
        
        foregroundNode!.addChild(playerNode!)
        
        //add some orb nodes
        for i in 0...19 {
            let orb = SKSpriteNode(imageNamed: "PowerUp")
            orb.position = CGPointMake(size.width / 2, size.height / 2 + CGFloat(i * 150))
            orb.physicsBody = SKPhysicsBody(circleOfRadius: orb.size.width / 2)
            orb.physicsBody!.dynamic = false
            orb.physicsBody!.categoryBitMask = CollisionCategoryPowerUpOrbs
            orb.physicsBody!.collisionBitMask = 0
            orb.name = PowerUpNodeName
            
            foregroundNode!.addChild(orb)
        }
        
        //debug
        print("Size of the screen is \(size.width) x \(size.height)")
        print("Size of the background image is \(backgroundNode!.size.width) x \(backgroundNode!.size.height)")
    }
    
    func didBeginContact(contact: SKPhysicsContact) {

        let nodeB = contact.bodyB.node!
        print("Collide, nodeB = \(nodeB.name)")

        if nodeB.name == PowerUpNodeName {
            nodeB.removeFromParent()
            ImpulseCount++
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        //use the first user's touch to start the game
        if !playerNode!.physicsBody!.dynamic {
            playerNode!.physicsBody!.dynamic = true;
        }
        
        //print("Touch")
        if ImpulseCount > 0 {
            playerNode!.physicsBody!.applyImpulse(CGVectorMake(0.0, 20.0))
            ImpulseCount--
        }
    }
    
    let ScrollThreshold: CGFloat = 360.0
    
    override func update(currentTime: NSTimeInterval) {
        if playerNode!.position.y >= ScrollThreshold {
            backgroundNode!.position = CGPointMake(backgroundNode!.position.x, -(playerNode!.position.y - ScrollThreshold)/8)
            foregroundNode!.position = CGPointMake(foregroundNode!.position.x, -(playerNode!.position.y - ScrollThreshold))
        }
    }
}

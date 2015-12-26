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
    var orbNode: SKSpriteNode?
    
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
        
        //add player node
        playerNode = SKSpriteNode(imageNamed: "Player")
        playerNode!.physicsBody = SKPhysicsBody(circleOfRadius: playerNode!.size.width / 2)

        playerNode!.physicsBody!.dynamic = true
        playerNode!.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        
        playerNode!.physicsBody!.linearDamping = 1.0
        playerNode!.physicsBody!.allowsRotation = false
        playerNode!.physicsBody!.categoryBitMask = CollisionCategoryPlayer
        playerNode!.physicsBody!.contactTestBitMask = CollisionCategoryPowerUpOrbs
        playerNode!.physicsBody!.collisionBitMask = 0
        
        addChild(playerNode!)
        
        //add some orb nodes
        orbNode = SKSpriteNode(imageNamed: "PowerUp")
        orbNode!.position = CGPoint(x: size.width / 2.0 + 10, y: size.height - 200)
        orbNode!.physicsBody = SKPhysicsBody(circleOfRadius: orbNode!.size.width / 2.0)
        orbNode!.physicsBody!.dynamic = false
        
        orbNode!.physicsBody!.categoryBitMask = CollisionCategoryPowerUpOrbs
        orbNode!.physicsBody!.collisionBitMask = 0
        
        orbNode!.name = PowerUpNodeName
        addChild(orbNode!)
        
        //debug
        print("Size of the screen is \(size.width) x \(size.height)")
        print("Size of the background image is \(backgroundNode!.size.width) x \(backgroundNode!.size.height)")
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let nodeB = contact.bodyB.node!
        
        print("Collide, nodeB = \(nodeB.name)")

        if nodeB.name == PowerUpNodeName {
            nodeB.removeFromParent()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        //print("Touch")

        playerNode!.physicsBody!.applyImpulse(CGVectorMake(0.0, 20.0))
        /* Called when a touch begins */
        
//        for touch in touches {
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
//        }
    }
}

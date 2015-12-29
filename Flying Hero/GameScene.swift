//
//  GameScene.swift
//  Flying Hero
//
//  Created by Quynh Nguyen on 24/12/2015.
//  Copyright (c) 2015 Quynh Nguyen. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var backgroundNode: SKSpriteNode?
    var playerNode: SKSpriteNode?
    var foregroundNode: SKSpriteNode?
    var orbNode: SKSpriteNode?
    
    var ImpulseCount: Int = 10
    
    let CollisionCategoryPlayer: UInt32 = 0x1 << 1
    let CollisionCategoryPowerUpOrbs: UInt32 = 0x1 << 2
    let CollisionCategoryBlackHoles: UInt32 = 0x1 << 3
    
    let PowerUpNodeName: String = "PowerUpNode"
    let BlackHoleNodeName: String = "BlackHoleNode"
    let ScrollThreshold: CGFloat = 360.0
    
    let coreMotionManager = CMMotionManager()
    var xAxisAcceleration: CGFloat = 0.0
    
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
        playerNode!.physicsBody!.contactTestBitMask = CollisionCategoryPowerUpOrbs | CollisionCategoryBlackHoles
        playerNode!.physicsBody!.collisionBitMask = 0
        
        foregroundNode!.addChild(playerNode!)
        
        addOrbsToForeground()
        addBlackHolesToForeground()
        
        //debug
        print("Size of the screen is \(size.width) x \(size.height)")
        print("Size of the background image is \(backgroundNode!.size.width) x \(backgroundNode!.size.height)")
    }
    
    func addOrbsToForeground() {
        //add some orb nodes
        for i in 0...19 {
            let orb = SKSpriteNode(imageNamed: "PowerUp")
            orb.position = CGPointMake((size.width / 2 + CGFloat(i) * 100.0) % size.width, size.height / 2 + CGFloat(i * 300))
            orb.physicsBody = SKPhysicsBody(circleOfRadius: orb.size.width / 2)
            orb.physicsBody!.dynamic = false
            orb.physicsBody!.categoryBitMask = CollisionCategoryPowerUpOrbs
            orb.physicsBody!.collisionBitMask = 0
            orb.name = PowerUpNodeName
            
            foregroundNode!.addChild(orb)
        }
    }
    
    func addBlackHolesToForeground() {
        let textureAtlas = SKTextureAtlas(named: "sprites.atlas")
        let frame0 = textureAtlas.textureNamed("BlackHole0")
        let frame1 = textureAtlas.textureNamed("BlackHole1")
        let frame2 = textureAtlas.textureNamed("BlackHole2")
        let frame3 = textureAtlas.textureNamed("BlackHole3")
        let frame4 = textureAtlas.textureNamed("BlackHole4")
        let blackHoleTextures = [frame0, frame1, frame2, frame3, frame4]
        let animateAction = SKAction.animateWithTextures(blackHoleTextures, timePerFrame: 0.2)
        let rotateAction = SKAction.repeatActionForever(animateAction)
        
        let moveLeftAction = SKAction.moveToX(0.0, duration: 6.0)
        let moveRightAction = SKAction.moveToX(size.width, duration: 6.0)
        let actionSequence =  SKAction.sequence([moveLeftAction, moveRightAction])
        let moveAction = SKAction.repeatActionForever(actionSequence)
        
        for i in 1...10 {
            let blackHole = SKSpriteNode(imageNamed: "BlackHole0")
            blackHole.position = CGPointMake(size.width - 100, 600.0 * CGFloat(i))
            blackHole.physicsBody = SKPhysicsBody(circleOfRadius: blackHole.size.width / 2)
            blackHole.physicsBody!.dynamic = false
            blackHole.physicsBody!.categoryBitMask = CollisionCategoryBlackHoles
            blackHole.physicsBody!.collisionBitMask = 0
            blackHole.name = BlackHoleNodeName
            
            blackHole.runAction(moveAction)
            blackHole.runAction(rotateAction)
            foregroundNode!.addChild(blackHole)
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {

        let nodeB = contact.bodyB.node!
        print("Collide, nodeB = \(nodeB.name)")

        if nodeB.name == PowerUpNodeName { //one more point
            nodeB.removeFromParent()
            ImpulseCount++
        }
        else if nodeB.name == BlackHoleNodeName { //die
            playerNode!.physicsBody!.contactTestBitMask = 0
            ImpulseCount = 0
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        //use the first user's touch to start the game
        if !playerNode!.physicsBody!.dynamic {
            playerNode!.physicsBody!.dynamic = true;
            
            self.coreMotionManager.accelerometerUpdateInterval = 0.3 //refresh rate = 0.3 second
            self.coreMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {
                
                (data, error) in
                
                if let _ = error {
                    print("Error with Accelerometer")
                }
                else {
                    self.xAxisAcceleration = CGFloat(data!.acceleration.x)
                }
            })
            

        
        }
        
        //print("Touch")
        if ImpulseCount > 0 {
            playerNode!.physicsBody!.applyImpulse(CGVectorMake(0.0, 30.0))
            ImpulseCount--
        }
    }

    
    override func update(currentTime: NSTimeInterval) {
        if playerNode!.position.y >= ScrollThreshold {
            backgroundNode!.position = CGPointMake(backgroundNode!.position.x, -(playerNode!.position.y - ScrollThreshold)/8)
            foregroundNode!.position = CGPointMake(foregroundNode!.position.x, -(playerNode!.position.y - ScrollThreshold))
        }
    }
    
    override func didSimulatePhysics() {
        
        //update velocity of the player
        // steer left-right using the accelerometer
        self.playerNode!.physicsBody!.velocity = CGVectorMake(self.xAxisAcceleration * 380, self.playerNode!.physicsBody!.velocity.dy)
        
        if playerNode!.position.x < -(playerNode!.size.width / 2) {
            playerNode!.position = CGPointMake(size.width - playerNode!.size.width / 2, playerNode!.position.y)
        }
        else if self.playerNode!.position.x > self.size.width {
            playerNode!.position = CGPointMake(playerNode!.size.width / 2, playerNode!.position.y)
        }
    }
    
    deinit {
        self.coreMotionManager.stopAccelerometerUpdates()
    }
}

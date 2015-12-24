//
//  GameScene.swift
//  Flying Hero
//
//  Created by Quynh Nguyen on 24/12/2015.
//  Copyright (c) 2015 Quynh Nguyen. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var backgroundNode: SKSpriteNode?
    var playerNode: SKSpriteNode?
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }

    override init(size: CGSize){
        super.init(size: size)
        
        backgroundColor  = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        //adding background node
        backgroundNode = SKSpriteNode(imageNamed: "Background")
        backgroundNode!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundNode!.position = CGPoint(x: size.width / 2.0, y: 0.0)
        addChild(backgroundNode!)
        
        //add player node
        playerNode = SKSpriteNode(imageNamed: "Player")
        playerNode!.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        addChild(playerNode!)
    }
}

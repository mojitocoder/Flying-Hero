//
//  GameScene.swift
//  Flying Hero
//
//  Created by Quynh Nguyen on 24/12/2015.
//  Copyright (c) 2015 Quynh Nguyen. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }

    override init(size: CGSize){
        super.init(size: size)
        backgroundColor  = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
}

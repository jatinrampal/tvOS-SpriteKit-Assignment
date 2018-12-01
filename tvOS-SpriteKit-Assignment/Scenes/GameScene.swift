//
//  GameScene.swift
//  tvOS-SpriteKit-Assignment
//
//  Created by Jatin Rampal on 2018-11-28.
//  Copyright © 2018 Jatin Rampal. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory{
    static let None : UInt32 = 0
    static let All : UInt32 = UInt32.max
    static let Villain : UInt32 = 0b1
    static let Hero : UInt32 = 0b10
    
    static let projectile : UInt32 = 0b11
    
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var background = SKSpriteNode(imageNamed: "mariobg.jpg")
    private var sportNode : SKSpriteNode?
    
    private var score : Int?
    let scoreIncrement = 10
    private var lblScore : SKLabelNode?
    
    override func didMove(to view: SKView) {
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        background.size = CGSize(width: 1024, height: 576)
        background.alpha = 0.7
        addChild(background)
        
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        sportNode = SKSpriteNode(imageNamed: "mario.png")
        sportNode?.position = CGPoint(x: 40, y: 50)
        sportNode?.alpha = 1
        sportNode?.size = CGSize(width: 160, height: 200)
        addChild(sportNode!)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self;
        
        sportNode?.physicsBody = SKPhysicsBody(circleOfRadius: (sportNode?.size.width)!/2)
        sportNode?.physicsBody?.isDynamic = true
        sportNode?.physicsBody?.categoryBitMask = PhysicsCategory.Hero
        sportNode?.physicsBody?.contactTestBitMask = PhysicsCategory.Villain
        sportNode?.physicsBody?.collisionBitMask = PhysicsCategory.None
        sportNode?.physicsBody?.usesPreciseCollisionDetection = true
        sportNode?.physicsBody?.isDynamic = true
        
        
        
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addVillain), SKAction.wait(forDuration: 0.5)])))
        
        score = 0
        self.lblScore = self.childNode(withName: "//scoreLabel") as? SKLabelNode
        self.lblScore?.text = "Score: \(score!)"
        
        if let sLabel = self.lblScore{
            sLabel.alpha = 0.0
            sLabel.run(SKAction.fadeIn(withDuration: 2.0))
        }
    }
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xffffffff)
    }
    
    func  random(min: CGFloat , max:CGFloat) -> CGFloat {
        return random() * (max-min) + min
    }
    
    func addVillain(){
        let villain = SKSpriteNode(imageNamed: "bowser.png")
        let actualY = random(min: villain.size.height/2, max: size.height - villain.size.height/2)
        villain.position = CGPoint(x: size.width + villain.size.width/2, y: actualY)
        villain.size = CGSize(width: 160, height: 200)
        villain.alpha = 1
        addChild(villain)
        
        villain.physicsBody = SKPhysicsBody(rectangleOf: villain.size)
        villain.physicsBody?.isDynamic = true
        villain.physicsBody?.categoryBitMask = PhysicsCategory.Villain
        villain.physicsBody?.contactTestBitMask = PhysicsCategory.Hero
        villain.physicsBody?.collisionBitMask = PhysicsCategory.None
        //I added this
        villain.physicsBody?.isDynamic = true
        
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        let actionMove = SKAction.move(to: CGPoint(x: -villain.size.width/2, y: actualY), duration: TimeInterval (actualDuration))
        
        let actionMoveDone = SKAction.removeFromParent()
        
        villain.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        
        
    }
    
    func marioDidCollideWithBowser(mario : SKSpriteNode, bowser : SKSpriteNode){
        print("hit")
        
        if let particles = SKEmitterNode(fileNamed: "collissionParticle.sks") {
            particles.position = mario.position
            particles.run(SKAction.sequence([SKAction.wait(forDuration: 2.0),SKAction.fadeOut(withDuration: 1.0), SKAction.removeFromParent()]))
            addChild(particles)
        }
        
        
        score = score! + scoreIncrement
        self.lblScore?.text = "Score: \(score!)"
        if let sLabel = self.lblScore{
            sLabel.alpha = 0.0
            sLabel.run(SKAction.fadeIn(withDuration: 2.0))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody : SKPhysicsBody
        var secondBody : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else
        {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if((firstBody.categoryBitMask & PhysicsCategory.Villain != 0) && (secondBody.categoryBitMask & PhysicsCategory.Hero != 0)){
            marioDidCollideWithBowser(mario: firstBody.node as! SKSpriteNode, bowser: secondBody.node as! SKSpriteNode)
        }
    }
    
    func moveMario(toPoint pos : CGPoint){
        let actionMove = SKAction.move(to: pos, duration: TimeInterval(2.0))
        let actionMoveDone = SKAction.rotate(byAngle: CGFloat(360.0), duration: TimeInterval(2.0))
        sportNode?.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
        moveMario(toPoint: pos)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
        moveMario(toPoint: pos)
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
////////////////////////////////////////////////////////////////////
// ARWorldTrackingConfiguration - this allows you to track your position and orientation of your device in relation to the real world at all times, can't display 3D content. Make sure as soon as sceneview loads, we want to run this
////////////////////////////////////////////////////////////////////
    
    let configuation = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
////////////////////////////////////////////////////////////////////
// helps us to debug the app by showing us if the world origin and our feature points are constantly be discovered
// world origin shows us our starting position and feature points shows us features around us
////////////////////////////////////////////////////////////////////
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.autoenablesDefaultLighting = true // now allows orange light to be able to be reflected (omni is the default - light that is spread across the entire scene)
        
        self.sceneView.session.run(configuation)
    }

    @IBAction func add(_ sender: Any) {
        
////////////////////////////////////////////////////////////////////
//      A node is simply a position in space, it has no shape, no size and no colour
//      We want to position our node in the root node. Our root node is our starting position!
        
//      If I make something a child node of the root node, it'll be positioned relative to the root node. Recall nodes on their own don't have any attributes so we need to give it some e.g. geometry - chamferRadius how round the shape is
////////////////////////////////////////////////////////////////////
        
        let node = SCNNode()
        
// firstMaterial - appearance, diffuse - the colour that's spread across the entire surface

////////////////////////////////////////////////////////////////////
/*
         DIFFERENT SHAPES GALLERY!!!!
         
         CAPSULE: node.geometry = SCNCapsule(capRadius: 0.1, height: 0.3) - capRadius measures how thick it is
         CONE: node.geometry = SCNCone(topRadius: 0, bottomRadius: 0.3, height: 0.3) - topRadius is the tip
         CYLINDER: node.geometry = SCNCylinder(radius: 0.2, height: 0.2)
         SPHERE: node.geometry = SCNSphere(radius: 0.2)
         TUBE: node.geometry = SCNTube(innerRadius: 0.2, outerRadius: 0.3, height: 0.5) // innerRadius how wide the hole is
         TORUS (bball hoop): node.geometry = SCNTorus(ringRadius: 0.3, pipeRadius: 0.1) // pipeRadius: thickness of the pipe
         PLANE (roads): node.geometry = SCNPlane(width: 0.2, height: 0.2)
         PYRAMID: node.geometry = SCNPyramid(width: 0.2, height: 0.4, length: 0.2)
 */
////////////////////////////////////////////////////////////////////
        
////////////////////////////////////////////////////////////////////
// CUSTOM DRAW A SHAPE OF A HOUSE USING UIBEZIERPATH
////////////////////////////////////////////////////////////////////
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0.2)) // just go up
        path.addLine(to: CGPoint(x: 0.2, y: 0.3)) // now go diagonal up
        path.addLine(to: CGPoint(x: 0.4, y: 0.2))
        path.addLine(to: CGPoint(x: 0.4, y: 0))
        
        let shape = SCNShape(path: path, extrusionDepth: 0.2) // extrusiondepth = thickness of path, in this case house
        node.geometry = shape
        
        node.geometry?.firstMaterial?.specular.contents = UIColor.orange // specular that is light that is reflected off a surface, but we need to give the scene view a source of light for it to be able to reflect it
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        
////////////////////////////////////////////////////////////////////
// we need to create a coordinate, a position - red (horizontal x axis), green (vertical y axis), blue (depth z axis), SCNVector3 is a 3D vector
// how far something away is relative to our starting position (root node)
////////////////////////////////////////////////////////////////////
        
        node.position = SCNVector3(0,0,-0.7) // 0.7 metres in front of us
        self.sceneView.scene.rootNode.addChildNode(node)

    }
    
    @IBAction func reset(_ sender: Any) {
        
////////////////////////////////////////////////////////////////////
// every time I click add, I'm adding another blue box in the same position, we just can't see it. How can we change the box position? Reset tracking and change starting position!!
////////////////////////////////////////////////////////////////////
        
        self.restartSession()
    }
    
    func restartSession() {
        self.sceneView.session.pause() // pauses current position
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in // enumerate through every child node, the box node being one of them
            node.removeFromParentNode() // remove box from parent node, remove from scene view
        }
        self.sceneView.session.run(configuation, options: [.resetTracking, .removeExistingAnchors]) // forget about old starting position and make a new one based on where we are at the moment and remove existing anchors (position and orientation info)
    }
    
    
////////////////////////////////////////////////////////////////////
// creating multiple shapes
// function takes a min float value and a max float value and generates a float value inbetween
// this will be used to place a box in random directions instead of just 1
////////////////////////////////////////////////////////////////////
    
    func randomNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
}


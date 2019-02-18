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

        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.autoenablesDefaultLighting = true // now allows orange light to be able to be reflected (omni is the default - light that is spread across the entire scene)
        
        self.sceneView.session.run(configuation)
    }

    @IBAction func add(_ sender: Any) {
        
////////////////////////////////////////////////////////////////////
// create a pyramid that sits on top of a box to create a house shape
// add a door
////////////////////////////////////////////////////////////////////
        
        
        let node = SCNNode()
        node.geometry = SCNPyramid(width: 0.1, height: 0.1, length: 0.1)
        node.geometry?.firstMaterial?.specular.contents = UIColor.orange
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        
        let boxNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        
        let doorNode = SCNNode(geometry: SCNPlane(width: 0.03, height: 0.06)) // remember a plane is like a flat surface
        doorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        
        let frontWindowNode = SCNNode(geometry: SCNPlane(width: 0.03, height: 0.03))
        frontWindowNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        
        let textNode = SCNNode()
        let text = SCNText(string: "JC's room!!!", extrusionDepth: 1)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.black
        text.materials = [material]
        
        textNode.position = SCNVector3(x: 0, y: 0.3, z: 0.5)
        textNode.scale = SCNVector3(0.001, 0.001, 0.001)
        textNode.geometry = text
        
        node.position = SCNVector3(0, 0, -0.3)
        
        boxNode.position = SCNVector3(0, -0.05, 0) // remember that coordinate is in the centre of the shape
        doorNode.position = SCNVector3(0.025, -0.02, 0.051) // flashing light is because the plane is right on the surface
        frontWindowNode.position = SCNVector3(-0.025, 0.01, 0.051)
        
        
        textNode.geometry = text
        textNode.position = SCNVector3(-0.1, 0.1, 0)
        
        self.sceneView.scene.rootNode.addChildNode(node)
        node.addChildNode(boxNode)
        node.addChildNode(textNode)
        boxNode.addChildNode(doorNode)
        boxNode.addChildNode(frontWindowNode)
        
/*
THE FOLLOWING CREATES A CYLINDER THAT POSITIONS ITSELF RELATIVE TO THE PYRAMID, RATHER THAN HAVING TO ADD BOTH AS A CHILD VIEW
         
        let node = SCNNode()

        node.geometry = SCNPyramid(width: 0.1, height: 0.1, length: 0.1)
        node.geometry?.firstMaterial?.specular.contents = UIColor.orange // specular that is light that is reflected off a surface, but we need to give the scene view a source of light for it to be able to reflect it
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        
        node.position = SCNVector3(0.2,0.3,-0.2)
        self.sceneView.scene.rootNode.addChildNode(node)
        
        // here we are creating a cylinder that will be 0.3 left of pyramid, 0.2 above and 0.3 behind
        
        let cylinderNode = SCNNode()

        cylinderNode.geometry = SCNCylinder(radius: 0.05, height: 0.05)
        cylinderNode.geometry?.firstMaterial?.specular.contents = UIColor.purple
        cylinderNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        
        cylinderNode.position = SCNVector3(-0.3,0.2,-0.3)
        node.addChildNode(cylinderNode) // now we can position the cylinder relative of the pyramid
*/
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


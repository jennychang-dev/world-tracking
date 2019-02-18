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
// EULER ANGLES - THREE ANGLES INTRODUCED TO DESCRIBE THE ORIENTATION OF A RIGID BODY WITH RESPECT TO A FIXED COORDINATE SYSTEM
        
        // IF I WANT TO ROTATE THE PYRAMID 90 DEGREES VERTICALLY WE ROTATE AROUND X
        // IF I WANT TO ROTATE THE PYRAMID 90 DEGREES HORIZONTALLY WE ROTATE AROUND Y
        // IF I WANT TO ROTATE THE PYAMOID 90 DEGREES CLOCKWISE WE ROTATE AROUND Z
        // WE HAVE TO CONVERT DEGREES TO RADIANS (FUNCTION BELOW)
        
// CHILD NODES ROTATE WITH PARENT NODES TO PRESERVE THEIR RELATIVE ORIENTATION
        
////////////////////////////////////////////////////////////////////
/*
        let cylinder = SCNNode(geometry: SCNCylinder(radius: 0.1, height: 0.1))
        cylinder.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        cylinder.position = SCNVector3(0, 0, -0.3)
        cylinder.eulerAngles = SCNVector3(-90.degreesToRadians, 0, 0) // this makes pyramid fall below cylinder
        self.sceneView.scene.rootNode.addChildNode(cylinder)
        
////////////////////////////////////////////////////////////////////
// RELATIVE ROTATION - IF I ROTATE THE CYLINDER BY 90 DEGREES, THE PYRAMID WILL ROTATE WITH IT
////////////////////////////////////////////////////////////////////
        
        let pyramid = SCNNode(geometry: SCNPyramid(width: 0.1, height: 0.1, length: 0.1))
        pyramid.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        pyramid.position = SCNVector3(0, 0, -0.5) // 0.5m behind the cylinder
        pyramid.eulerAngles = SCNVector3(0, 0, 0)
        cylinder.addChildNode(pyramid)
*/
     
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
        let text = SCNText(string: "WHY NOT CREATE 3D TEXT IN THE MIDDLE OF NOWHERE", extrusionDepth: 1)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.black
        text.materials = [material]
        
        textNode.position = SCNVector3(x: 0, y: 0.3, z: 0.5)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        textNode.geometry = text
        
        node.position = SCNVector3(0, 0, -0.3)
        node.eulerAngles = SCNVector3(0, 0, 0)
        // If I put Float(180.degreesToRadians) in X --> WAHEY HOUSE IS NOW UPSIDE DOWN!! 
        
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

extension Int {
    var degreesToRadians: Double {
        return Double(self) * .pi/180}
}


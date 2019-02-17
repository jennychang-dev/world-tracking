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
        
        self.sceneView.session.run(configuation)
    }

    @IBAction func add(_ sender: Any) {
        
        print("pressing")
        
////////////////////////////////////////////////////////////////////
//      A node is simply a position in space, it has no shape, no size and no colour
//      We want to position our node in the root node. Our root node is our starting position!
        
//      If I make something a child node of the root node, it'll be positioned relative to the root node. Recall nodes on their own don't have any attributes so we need to give it some e.g. geometry - chamferRadius how round the shape is
////////////////////////////////////////////////////////////////////
        
        let node = SCNNode()
        
////////////////////////////////////////////////////////////////////
// firstMaterial - appearance, diffuse - the colour that's spread across the entire surface
////////////////////////////////////////////////////////////////////
        
        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        
////////////////////////////////////////////////////////////////////
// we need to create a coordinate, a position - red (horizontal x axis), green (vertical y axis), blue (depth z axis), SCNVector3 is a 3D vector
// how far something away is relative to our starting position (root node)
////////////////////////////////////////////////////////////////////
        
        // -0.3, -0.2, -0.5
        node.position = SCNVector3(-0.3,-0.2,-0.5)
        self.sceneView.scene.rootNode.addChildNode(node)

////////////////////////////////////////////////////////////////////
// now if I were to 'add' my box, it'll get placed right where the starting position is (0,0,0) - (x,y,z)
////////////////////////////////////////////////////////////////////
        
    }
}


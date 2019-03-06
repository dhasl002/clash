/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main view controller for the AR experience.
*/

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var placeButton: UIButton!
    
    var semiTransparentAsset = false
    var modifiableAsset: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("""
                ARKit is not available on this device. For apps that require ARKit
                for core functionality, use the `arkit` key in the key in the
                `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
                the app from installing. (If the app can't be installed, this error
                can't be triggered in a production scenario.)
                In apps where AR is an additive feature, use `isSupported` to
                determine whether to show UI for launching AR experiences.
            """) // For details, see https://developer.apple.com/documentation/arkit
        }
        
        // Start the view's AR session.
        sceneView.session.delegate = self
        sceneView.session.run(defaultConfiguration)
        
        sceneView.debugOptions = [ .showFeaturePoints ]
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let mat = SCNMatrix4(frame.camera.transform)
        let cameraDirection = SCNVector3(mat.m31, mat.m32, mat.m33)
        let cameraPosition = SCNVector3(mat.m41, mat.m42, mat.m43)
        
        if semiTransparentAsset {
            let hitPos = getCenterHitPosition()
            modifiableAsset?.position = hitPos
        }
    }

    /// - Tag: RestoreVirtualContent
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Place content only for anchors found by plane detection.
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // Create a custom object to visualize the plane geometry and extent.
        let plane = Plane(anchor: planeAnchor, in: sceneView)
        
        // Add the visualization to the ARKit-managed node so that it tracks
        // changes in the plane anchor as plane estimation continues.
        node.addChildNode(plane)
    }
    
    /// - Tag: UpdateARContent
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // Update only anchors and nodes set up by `renderer(_:didAdd:for:)`.
        guard let planeAnchor = anchor as? ARPlaneAnchor,
            let plane = node.childNodes.first as? Plane
            else { return }
        
        // Update ARSCNPlaneGeometry to the anchor's new estimated shape.
        if let planeGeometry = plane.meshNode.geometry as? ARSCNPlaneGeometry {
            planeGeometry.update(from: planeAnchor.geometry)
        }
        
        // Update extent visualization to the anchor's new bounding rectangle.
        if let extentGeometry = plane.extentNode.geometry as? SCNPlane {
            extentGeometry.width = CGFloat(planeAnchor.extent.x)
            extentGeometry.height = CGFloat(planeAnchor.extent.z)
            plane.extentNode.simdPosition = planeAnchor.center
        }
        
        // Update the plane's classification and the text position
        if #available(iOS 12.0, *),
            let classificationNode = plane.classificationNode,
            let classificationGeometry = classificationNode.geometry as? SCNText {
            let currentClassification = planeAnchor.classification.description
            if let oldClassification = classificationGeometry.string as? String, oldClassification != currentClassification {
                classificationGeometry.string = currentClassification
                classificationNode.centerAlign()
            }
        }
        
    }
    
    var defaultConfiguration: ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }
    
    @IBAction func placeAsset() {
        if !semiTransparentAsset {
            semiTransparentAsset = true
            let hitPos = getCenterHitPosition()
            modifiableAsset = loadCubeAsset(position: hitPos, name: "tmp")
            modifiableAsset?.opacity = 0.4
            sceneView.scene.rootNode.addChildNode(modifiableAsset!)
        } else {
            semiTransparentAsset = false
        }
    }
    
    func getCenterHitPosition() -> SCNVector3 {
        let hitTestResult = sceneView.hitTest(sceneView.center, types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane]).first
        let hitPosition = SCNVector3(hitTestResult!.worldTransform.columns.3.x,
                                     hitTestResult!.worldTransform.columns.3.y,
                                     hitTestResult!.worldTransform.columns.3.z)
        return hitPosition
    }
    
    func loadCubeAsset(position: SCNVector3, name: String) -> SCNNode{
        guard let sceneURL = Bundle.main.url(forResource: "barn", withExtension: "scn", subdirectory: "Assets.scnassets"),
            let referenceNode = SCNReferenceNode(url: sceneURL) else {
                fatalError("can't load virtual object")
        }
        referenceNode.load()
        referenceNode.position = position
        referenceNode.name = name
        referenceNode.scale = SCNVector3(0.005, 0.005, 0.005)
        
        return referenceNode
    }

    @IBAction func handleSceneTap(_ sender: UITapGestureRecognizer) {
        modifiableAsset?.opacity = 1
        semiTransparentAsset = false
        modifiableAsset = nil
    }
}


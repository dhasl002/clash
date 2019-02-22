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

    /// - Tag: RestoreVirtualContent
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    }
    
    var defaultConfiguration: ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }
    

    @IBAction func handleSceneTap(_ sender: UITapGestureRecognizer) {
        guard let hitTestResult = sceneView
            .hitTest(sender.location(in: sceneView), types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
            .first
            else { return }
        

        let hitPosition = SCNVector3(hitTestResult.worldTransform.columns.3.x,
                                     hitTestResult.worldTransform.columns.3.y,
                                     hitTestResult.worldTransform.columns.3.z)

        guard let sceneURL = Bundle.main.url(forResource: "cube", withExtension: "scn", subdirectory: "Assets.scnassets"),
            let referenceNode = SCNReferenceNode(url: sceneURL) else {
                fatalError("can't load virtual object")
        }
        referenceNode.load()
        
        referenceNode.position = hitPosition
        referenceNode.scale = SCNVector3(0.1, 0.1, 0.1)
        sceneView.scene.rootNode.addChildNode(referenceNode)
    }
}


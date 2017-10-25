import MetalKit

protocol SceneDelegate {
  func transition(to scene: Scene)
}

class Scene: Node {
  var device: MTLDevice
  var size: CGSize {
    didSet {
      sceneSizeWillChange(to: size)
    }
  }
  var camera = Camera()
  var sceneConstants = SceneConstants()
  var light = Light()
  var sceneDelegate: SceneDelegate?
  
  init(device: MTLDevice, size: CGSize) {
    self.device = device
    self.size = size
    super.init()
    camera.position.z = -6
    add(childNode: camera)
  }
  
  func update(deltaTime: Float) {}
  
  func render(commandEncoder: MTLRenderCommandEncoder,
              deltaTime: Float) {
    update(deltaTime: deltaTime)
    sceneConstants.projectionMatrix = camera.projectionMatrix
    commandEncoder.setFragmentBytes(&light,
                                    length: MemoryLayout<Light>.stride,
                                    index: 3)
    
    commandEncoder.setVertexBytes(&sceneConstants,
                                  length: MemoryLayout<SceneConstants>.stride,
                                  index: 2)
    for child in children {
      child.render(commandEncoder: commandEncoder,
                   parentModelViewMatrix: camera.viewMatrix)
    }
  }
  
  func sceneSizeWillChange(to size: CGSize) {
    camera.aspect = Float(size.width / size.height)
  }
  
  func touchesBegan(_ view: UIView, touches: Set<UITouch>,
                    with event: UIEvent?) {}
  
  func touchesMoved(_ view: UIView, touches: Set<UITouch>,
                    with event: UIEvent?) {}
  
  func touchesEnded(_ view: UIView, touches: Set<UITouch>,
                    with event: UIEvent?) {}
  
  func touchesCancelled(_ view: UIView, touches: Set<UITouch>,
                        with event: UIEvent?) {}
}

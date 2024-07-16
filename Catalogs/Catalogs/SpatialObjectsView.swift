//
//  Created 7/12/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI
import RealityKit


struct SpatialObjectsView: View {
    
    let viewModel: CatalogsViewModel
    
    @State private var baseTransform: Transform?
    @State private var baseMagnification: SIMD3<Float>?
    private let startPosition: SIMD3<Float> = SIMD3(x: 0, y: 1.5, z: -1.5)
    
    var body: some View {
        
        RealityView { _ in
            // Intentionally blank
        } update: { content in
            let entity = loadSelectedObject()
            content.add(entity)
        } placeholder: {
            ProgressView()
        }
        .gesture(dragGesture)
        .simultaneousGesture(rotateGesture)
        .simultaneousGesture(magnifyGesture)
        .simultaneousGesture(doubleTapGesture)
    }
    
    private func loadSelectedObject() -> Entity {
        guard let url = viewModel.selectedObject?.modelUrl,
              let entity = try? Entity.load(contentsOf: url)
        else {
            print("Unable to load \(String(describing: viewModel.selectedObject?.modelUrl))")
            return Entity()
        }
        
        entity.position = startPosition
        configure(entity: entity)
        print(entity)
        
        return entity
    }
}

// MARK: - Gesture Support
extension SpatialObjectsView {
    
    var dragGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                let entity = value.entity
                if baseTransform == nil {
                    baseTransform = entity.transform
                }
                
                let translation = value.convert(value.translation3D, from: .local, to: entity.parent!)
                entity.transform.translation = baseTransform!.translation + translation
            }
            .onEnded { _ in
                baseTransform = nil
            }
    }
    
    var magnifyGesture: some Gesture {
        MagnifyGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                if baseMagnification == nil {
                    baseMagnification = value.entity.scale
                }
                
                let delta = Float(value.magnification - 1)
                value.entity.scale = max(baseMagnification! + .init(repeating: delta), 0.2)
            }
            .onEnded { _ in
                baseMagnification = nil
            }
    }
    
    var rotateGesture: some Gesture {
        RotateGesture3D(constrainedToAxis: .y)
            .targetedToAnyEntity()
            .onChanged { value in
                let entity = value.entity
                if baseTransform == nil {
                    baseTransform = entity.transform
                }
                
                let transform = Transform(AffineTransform3D(rotation: value.rotation))
                entity.transform.rotation = baseTransform!.rotation * transform.rotation
            }
            .onEnded { _ in
                baseTransform = nil
            }
    }
    
    var doubleTapGesture: some Gesture {
        TapGesture(count: 2)
            .targetedToAnyEntity()
            .onEnded { value in
                value.entity.toggleAnimation()
            }
    }
    
    private func configure(entity: Entity) {
        entity.generateCollisionShapes(recursive: true)
        entity.components.set(InputTargetComponent(allowedInputTypes: .indirect))
    }
}

// MARK: - Animation Support
struct MyAnimationComponent: Component {
    
    var isAnimating = false
}

extension Entity {
    
    var isAnimating: Bool {
        components[MyAnimationComponent.self]?.isAnimating ?? false
    }
    
    func toggleAnimation() {
        guard let animation = availableAnimations.first else { return }
        if isAnimating {
            stopAllAnimations()
        } else {
            playAnimation(animation.repeat(count: 0), transitionDuration: 1, startsPaused: false)
        }
        components[MyAnimationComponent.self] = MyAnimationComponent(isAnimating: !isAnimating)
    }
}

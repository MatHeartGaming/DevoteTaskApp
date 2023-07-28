//
//  BlurModifier.swift
//  DevoteTaskApp
//
//  Created by Matteo Buompastore on 28/07/23.
//

import SwiftUI

struct BlurModifier: ViewModifier {
    
    var isActive : Bool
    
    func body(content: Content) -> some View {
        content
            .blur(radius: isActive ? 8 : 0, opaque: false)
            .transition(.move(edge: .bottom))
            .animation(.easeOut(duration: 0.5), value: isActive)
            
    }
    
}

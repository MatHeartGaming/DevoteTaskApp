//
//  CheckboxStyle.swift
//  DevoteTaskApp
//
//  Created by Matteo Buompastore on 28/07/23.
//

import SwiftUI

struct CheckboxStyle: ToggleStyle {
    
    //MARK: - PROPERTIES
    
    //MARK: - BODY
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .foregroundColor(configuration.isOn ? .pink : .primary)
                .font(.system(size: 30, weight: .semibold, design: .rounded))
                .onTapGesture {
                    configuration.isOn.toggle()
                    
                    playSound(sound: configuration.isOn ? "sound-rise" : "sound-tap", type: "mp3")
                    feedback.notificationOccurred(.success)
                }
            
            configuration.label
        } //: HSTACK
    }
    
}


//MARK: - PREVIEW
struct CheckboxStyle_Previews: PreviewProvider {
    static var previews: some View {
        Toggle("Placeholder label", isOn: .constant(true))
            .toggleStyle(CheckboxStyle())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

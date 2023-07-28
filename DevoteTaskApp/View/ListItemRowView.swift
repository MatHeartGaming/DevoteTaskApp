//
//  ListItemRowView.swift
//  DevoteTaskApp
//
//  Created by Matteo Buompastore on 28/07/23.
//

import SwiftUI

struct ListItemRowView: View {
    
    //MARK: - PROPERTIES
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var item : Item
    
    //MARK: - BODY
    var body: some View {
        Toggle(isOn: $item.completion) {
            Text(item.task ?? "")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.heavy)
                .foregroundColor(item.completion ? .pink : .primary)
                .padding(.vertical, 12)
                .animation(.default, value: item.completion)
        } //: TOGGLE
        .toggleStyle(CheckboxStyle())
        .onReceive(item.objectWillChange) { _ in
            if self.viewContext.hasChanges {
                try? self.viewContext.save()
            }
        }
    }
}

//
//  NewTaskItemView.swift
//  DevoteTaskApp
//
//  Created by Matteo Buompastore on 28/07/23.
//

import SwiftUI

struct NewTaskItemView: View {
    
    //MARK: - PROPERTIES
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State var task : String = ""
    @Binding var isShowing : Bool
    private var isButtonDisabled : Bool {
        task.isEmpty
    }
    
    //MARK: - FUNCTIONS
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            createNew(item: newItem)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            task = ""
            hideKeyboard()
            withAnimation(.easeOut) {
                isShowing = false
            }
            playSound(sound: "sound-ding", type: "mp3")
            feedback.notificationOccurred(.success)
        }
    }
    
    private func createNew(item : Item) -> Item {
        item.id = UUID()
        item.completion = false
        item.task = task
        item.timestamp = Date()
        return item
    }
    
    //MARK: - BODY
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 16) {
                TextField("New Task", text: $task)
                    .foregroundColor(.pink)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .padding()
                    .background(
                        isDarkMode ? Color(UIColor.tertiarySystemBackground) : Color(UIColor.secondarySystemBackground)
                    )
                    .cornerRadius(10)
                
                Button(action: addItem) {
                    Spacer()
                    Text("SAVE")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Spacer()
                } //: BUTTON
                .disabled(isButtonDisabled)
                .onTapGesture {
                    if isButtonDisabled {
                        playSound(sound: "sound-tap", type: "mp3")
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(isButtonDisabled ? .blue.opacity(0.5) : .pink)
                .cornerRadius(10)
                .animation(.spring(), value: isButtonDisabled)
            } //: VSTACK
            .padding()
            .padding(.horizontal)
            .padding(.vertical, 20)
            .background(isDarkMode ? Color(UIColor.secondarySystemBackground) : .white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.65), radius: 24)
            .frame(maxWidth: 640)
        } //: VSTACK
        .padding()
        
    }
}


//MARK: - PREVIEW
struct NewTaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskItemView(isShowing: .constant(true))
            .preferredColorScheme(.dark)
    }
}

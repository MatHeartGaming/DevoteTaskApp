//
//  ContentView.swift
//  DevoteTaskApp
//
//  Created by Matteo Buompastore on 28/07/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    //MARK: - PROPERTY
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("isDarkMode") private var isDarkMode : Bool = false
    @State var task : String = ""
    @State private var showNewTaskItem = false
    
    // FETCHING DATA
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    //MARK: - FUNCTIONS
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    
    //MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack {
                //MARK: - MAIN VIEW
                VStack {
                    //MARK: - HEADER
                    HStack(spacing: 10) {
                        
                        // TITLE
                        Text("Devote")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.leading, 4)
                        
                        // EDIT BUTTON
                        EditButton()
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 10)
                            .frame(minWidth: 70, minHeight: 24)
                            .background(
                                Capsule()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                        
                        // APPEARENCE BUTTON
                        Button {
                            withAnimation(.easeInOut) {
                                isDarkMode.toggle()
                            }
                            playSound(sound: "sound-tap", type: "mp3")
                            feedback.notificationOccurred(.success)
                        } label: {
                            Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .font(.system(.title, design: .rounded))
                        }

                    } //: HSTACK
                    .padding()
                    .foregroundColor(.white)
                    
                    Spacer(minLength: 80)
                    
                    //MARK: - NEW TASK BUTTON
                    Button {
                        withAnimation(.easeIn(duration: 0.5)) {
                            showNewTaskItem = true
                        }
                        playSound(sound: "sound-ding", type: "mp3")
                        feedback.notificationOccurred(.success)
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(colors: [.pink, .blue], startPoint: .leading, endPoint: .trailing)
                            .clipShape(Capsule())
                    )
                    .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)

                    
                    //MARK: - TASKS
                    
                    
                    
                    List {
                        ForEach(items) { item in
                            ListItemRowView(item: item)
                        }
                        .onDelete(perform: deleteItems)
                    } //: LIST
                    .listStyle(.insetGrouped)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                    
                } //: VSTACK
                .modifier(BlurModifier(isActive: showNewTaskItem))
                
                //MARK: - NEW TASK ITEM
                if showNewTaskItem {
                    BlankView(
                        backgroundColor: isDarkMode ? .black : .gray,
                        backgroundOpacity: isDarkMode ? 0.3 : 0.5)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                showNewTaskItem = false
                            }
                        }
                    NewTaskItemView(isShowing: $showNewTaskItem)
                }
                
            } //: ZSTACK
            .navigationTitle("Daily Tasks")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarHidden(true)
            .background(
                BackgroundImageView()
                    .modifier(BlurModifier(isActive: showNewTaskItem))
            )
            .background(backgroundGradient.ignoresSafeArea())
            .onAppear {
                UITableView.appearance().backgroundColor = .clear
            }
        } //: NAVIGATION
        .navigationViewStyle(.stack)
    }
    
}


//MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .preferredColorScheme(.dark)
    }
}

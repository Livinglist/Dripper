//
//  ContentView.swift
//  Days
//
//  Created by Jiaqi Feng on 12/17/20.
//

import SwiftUI
import CoreData
import WidgetKit

struct ContentView: View {
    let defaults = UserDefaults.standard
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \DeletedItem.timestamp, ascending: false)],
        animation: .default)
    private var deletedItems: FetchedResults<DeletedItem>
    
    @State private var showModal = false
    
    @State private var txt: String = "Empty"
    
    var body: some View {
        NavigationView {
            List {
                if !items.isEmpty{
                    ForEach((0...items.count-1), id: \.self) {
                        let curItem = items[$0]
                        
                        
                        if $0 == 0 {
                            ItemView(curItem, withDateLabel: true).contextMenu{buildMenuItems(curItem: curItem)}
                        }else{
                            if curItem.timestamp!.month != items[$0-1].timestamp!.month {
                                ItemView(curItem, withDateLabel: true).contextMenu{buildMenuItems(curItem: curItem)}
                            }else{
                                ItemView( curItem).contextMenu{buildMenuItems(curItem: curItem)}
                                //Text("asd")
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination:TrashCanView()) {
                        Button(action: {
                            
                        }, label: {
                            Label("Trash Can", systemImage: "trash")
                        })
                    }
                    
                    #if os(iOS)
                    //EditButton()
                    #endif
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            
            
        }.sheet(isPresented: $showModal, onDismiss: {
            print(self.showModal)
        }) {
            TextEditView()
        }.onAppear(){
            if !defaults.bool(forKey: "First Launch"){
                defaults.setValue(true, forKey: "First Launch")
                
                let newItem = Item(context: viewContext)
                newItem.timestamp = Date()
                newItem.text = "My first time using this app!"
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
    }
    
    @ViewBuilder
    func buildMenuItems(curItem: Item) -> some View{
        Group {
            Button("Show on Widget", action: {
                defaults.setValue(true, forKey: "userHasSet")
                defaults.setValue(curItem.text, forKey: "widgetContent")
                WidgetCenter.shared.reloadAllTimelines()
            })
        }
    }
    
    private func addItem() {
        self.showModal = true
        //        withAnimation {
        //            let newItem = Item(context: viewContext)
        //            newItem.timestamp = Date()
        //            newItem.text = txt
        //
        //            do {
        //                try viewContext.save()
        //            } catch {
        //                // Replace this implementation with code to handle the error appropriately.
        //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //                let nsError = error as NSError
        //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        //            }
        //        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach {item in
                let deletedItem = DeletedItem(context: viewContext)
                deletedItem.text = item.text
                deletedItem.timestamp = item.timestamp
                deletedItem.imageData = item.imageData
                
                viewContext.delete(item)
            }
            
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
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

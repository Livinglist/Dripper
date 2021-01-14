//
//  TrashCanView.swift
//  Days
//
//  Created by Jiaqi Feng on 1/13/21.
//

import SwiftUI

struct TrashCanView: View {
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
    
    var body: some View {
        List {
            if !deletedItems.isEmpty{
                ForEach((0...deletedItems.count-1), id: \.self) {
                    let curItem = deletedItems[$0]

                    DeletedItemView(curItem)
                }
                .onDelete(perform: deleteItems)
            }
        }.listStyle(InsetGroupedListStyle())
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { deletedItems[$0] }.forEach {item in
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

struct TrashCanView_Previews: PreviewProvider {
    static var previews: some View {
        TrashCanView()
    }
}

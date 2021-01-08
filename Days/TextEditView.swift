//
//  TextEditView.swift
//  Days
//
//  Created by Jiaqi Feng on 1/7/21.
//

import SwiftUI

struct TextEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @State private var inputText = ""
        
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                })
                Spacer()
                Button(action: addItem, label: {
                    Text("Submit").padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(40)
                })
            }.padding()
            TextEditor(text: $inputText).padding(.horizontal)
            HStack{
                Spacer()
                Text("\(inputText.count)").foregroundColor(.gray).padding()
            }
        }
    }
    
    private func addItem(){
                    let newItem = Item(context: viewContext)
                    newItem.timestamp = Date()
                    newItem.text = inputText
        
                    viewContext.performAndWait {
                        try? viewContext.save()
                    }
        
        self.presentationMode.wrappedValue.dismiss()
        
    }
}

struct TextEditView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditView()
    }
}

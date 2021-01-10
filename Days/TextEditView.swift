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
    
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                })
                Spacer()
                Button(action: {
                    self.isShowPhotoLibrary = true
                }) {
                    HStack {
                        Image(systemName: "photo").frame(width: 10, height: 24,alignment: .center).padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                            
                        
//                        Text("Photo library")
//                            .font(.headline)
                    }
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(40)
                    
                }
                Button(action: addItem, label: {
                    Text("Drip").frame(width: 64, height: 24, alignment: .center).padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(40)
                })
            }.padding()
            if !self.image.size.equalTo(CGSize(width: 0, height: 0)){
            Image(uiImage: self.image)
                .resizable()
                .scaledToFit()
                .frame(minWidth: 0, minHeight: 0, maxHeight: 360)
                .edgesIgnoringSafeArea(.all)
                .cornerRadius(8)
                .padding()
            }
            TextEditor(text: $inputText).onReceive(inputText.publisher.collect()) {
                self.inputText = String($0.prefix(500))
            }.padding(.horizontal)
            HStack{
                Spacer()
                Text("\(inputText.count)").foregroundColor(.gray).padding()
            }
        }.sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }
    }
    
    private func addItem(){
        let newItem = Item(context: viewContext)
        
        #if DEBUG
        var dayComponent    = DateComponents()
        dayComponent.day    = 40 // For removing one day (yesterday): -1
        let theCalendar     = Calendar.current
        let nextDate        = theCalendar.date(byAdding: dayComponent, to: Date())
        newItem.timestamp = nextDate
        #else
        newItem.timestamp = Date()
        #endif
        newItem.text = inputText
        if self.image.imageAsset != nil{
            newItem.imageData = image.pngData()
        }
        
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

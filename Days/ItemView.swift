//
//  ItemView.swift
//  Days
//
//  Created by Jiaqi Feng on 1/9/21.
//

import SwiftUI

struct ItemView: View {
    var item:Item
    var withDateLabel = false
    
    init(_ item: Item, withDateLabel withLabel: Bool = false){
        self.item = item
        self.withDateLabel = withLabel
    }
    
    var body: some View {
        if withDateLabel{
            VStack{
                HStack{
                    Spacer()
                    Text("\(item.timestamp!.month)").font(.largeTitle)
                    Text("2021").font(.footnote)
                }.padding(.vertical)
                Text("\(item.text ?? "this is a test")").frame(maxWidth: .infinity,alignment:.leading)
                if item.imageData != nil {
                    Image(uiImage: UIImage(data: item.imageData!)!)
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 0, minHeight: 0, maxHeight: 160)
                        .edgesIgnoringSafeArea(.all)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                
                Text("\(item.timestamp!, formatter: itemFormatter)").font(.footnote).foregroundColor(.gray).frame(maxWidth: .infinity,alignment:.trailing)
            }.frame(alignment: .leading)
        }else{
            VStack{
                Text("\(item.text ?? "this is a test")").frame(maxWidth: .infinity,alignment:.leading)
                if item.imageData != nil {
                    Image(uiImage: UIImage(data: item.imageData!)!)
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 0, minHeight: 0, maxHeight: 160)
                        .edgesIgnoringSafeArea(.all)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                
                Text("\(item.timestamp!, formatter: itemFormatter)").font(.footnote).foregroundColor(.gray).frame(maxWidth: .infinity,alignment:.trailing)
            }.frame(alignment: .leading)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        Text("test")
    }
}



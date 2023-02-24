//
//  ContentView.swift
//  EpicSelfie
//
//  Created by Sirius Tao on 1/10/23.
//

import SwiftUI

struct EPICImage: Codable{
    var image:String
    var date:String
}

struct ContentView: View {
    @State var imageURL = ""
    
    func loadMetaData(){
        let year = 2022
        let month = 10
        let day = 24
        
        let url = URL(string:"https://epic.gsfc.nasa.gov/api/natural/date/\(year)-\(month)-\(day)")!
        var request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with:request){data, response, error in
            if let data =  data{
                //let metadataString = String(data: data, encoding:utf8)!
                //print(metadataString)
                let epicImages = try!JSONDecoder().decode([EPICImage].self,from:data)
                let imageName = epicImages[0].image
                imageURL = "https://epic.gsfc.nasa.gov/archive/natural/\(year)/\(month)/\(day)/png/\(imageName).png"
            } else if let error = error{
                print("HTTP Request Failed \(error)")
            }
        }
        task.resume()
    }
    var body: some View {
        VStack {
            AsyncImage(url:
                        URL(string:imageURL))
            { phase in
                if let image = phase.image{
                    image
                    .resizable()
                    .frame(width:300, height:300)
                } else if phase.error != nil{
                    Color.gray
                }else{
                    Color.blue
                }
            }
            Button("Load Image MetaData"){
                loadMetaData()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

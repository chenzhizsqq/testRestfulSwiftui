//
//  ContentView.swift
//  testRestfulSwiftui
//
//  Created by chenzhizs on 2023/03/28.
//

import SwiftUI
import Alamofire

struct webSiteApiTestViewPost: Decodable, Identifiable {
    let id: Int
    let title: String
    let body: String
}

struct ContentView: View {
       
    var body: some View {
        webSiteApiTestView()
    }
    
    //这是自己的一个接口
    func selfRESTfulApiView() -> some View {
        
        ZStack {
        }
    }
    
    
    //这是网上的一个接口
    @State private var posts: [webSiteApiTestViewPost] = []
    func webSiteApiTestView() -> some View {
        
        ZStack {
            List(posts, id: \.id) { post in
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .font(.subheadline)
                }
            }
            .onAppear {
                AF.request("https://jsonplaceholder.typicode.com/posts")
                    .validate()
                    .responseDecodable(of: [webSiteApiTestViewPost].self) { response in
                        guard let posts = response.value else { return }
                        self.posts = posts
                    }
            }
        }
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

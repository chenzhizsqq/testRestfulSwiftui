//
//  ContentView.swift
//  testRestfulSwiftui
//
//  Created by chenzhizs on 2023/03/28.
//

import SwiftUI
import Alamofire

//网上接口的数据结构
struct webSiteApiTestViewPost: Decodable, Identifiable {
    let id: Int
    let title: String
    let body: String
}

//自己接口的数据结构
struct GetFlowDataItem: Decodable, Identifiable {
    let id: Int
    let firstName: String
    let lastName: String
    let emailId: String
}

struct ContentView: View {
    
    @State private var errorMessage: String = ""
    @State private var isShowingAlert: Bool = false
    
    var body: some View {
        //对应自己做的一个接口
        viewJsonGetAll()
        
        //对应网上的一个接口
        webSiteApiTestView()
    }
    
    //这是自己的一个接口
    @State private var getFlowDataItem: [GetFlowDataItem] = []
    func requestGetAll() {
         AF.request("http://192.168.1.3:8080/api/v1/employees",method: .get)
            .validate()
            .responseDecodable(of: [GetFlowDataItem].self) { response in
                switch response.result {
                case .success:
                    guard let gets = response.value else { return }
                    self.getFlowDataItem = gets
                case let .failure(error):
                    print("Error: \(error)")
                    self.errorMessage = error.localizedDescription
                    self.isShowingAlert = true
                }
        }
    }
    
    //获取自己接口的json get all
    func viewJsonGetAll() -> some View {
        ZStack {
            
            VStack {
                List(getFlowDataItem, id: \.id) { get in
                    VStack(alignment: .leading) {
                        Text(String(get.id))
                            .font(.headline)
                        Text(get.firstName)
                        Text(get.lastName)
                        Text(get.emailId)
                    }
                }
                Button(action: {
                    requestGetAll()
                }, label: {
                    Text("接收GET ALL")
                })
            }
            .onAppear(){
                requestGetAll()
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    
    //这是网上的一个接口
    @State private var posts: [webSiteApiTestViewPost] = []
    //获取网上接口的数据
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

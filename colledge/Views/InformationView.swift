//
//  AnnoncementView.swift
//  colledge
//
//  Created by Ромка Бережной on 16.03.2022.
//

import SwiftUI

struct InformationView: View {
    
    @State private var links: [AnnoncementLink] = [
        AnnoncementLink(
            url: URL(string: "http://nke.ru/")!,
            imageType: .system,
            image: "network",
            name: "Website"
        ),
        AnnoncementLink(
            url: URL(string: "https://vk.com/gr_nke")!,
            imageType: .network,
            image: "https://papik.pro/uploads/posts/2021-11/thumbs/1636091024_64-papik-pro-p-vkontakte-logotip-foto-68.png",
            name: "VK"
        ),
        AnnoncementLink(
            url: URL(string: "https://t.me/edunke")!,
            imageType: .network,
            image: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/Telegram_logo.svg/2048px-Telegram_logo.svg.png",
            name: "Telegram"
        )
    ]
    @State private var news: [News] = []
    @State private var annoncements: [Annoncement] = []
    
    var body: some View {
        NavigationView {
            VStack(alignment:.leading) {
                HStack(spacing: 20) {
                    ForEach(links) { link in
                        AnnoncementLinkView(link: link)
                    }
                }
                .padding(.top, 10)
                ScrollView {
                    VStack(alignment: .leading) {
                    if news.count == 0 {
                        Text("Пока без новостей")
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, UIScreen.main.bounds.height / 4)
                    } else {
                        ForEach(news, id:\.id) { news in
                            NewsView(news: news)
                        }
                    }
                    Text("Анонсы")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    if annoncements.count == 0 {
                        Spacer()
                        Text("")
                        Spacer()
                    } else {
                        ForEach(annoncements, id:\.id) { annoncement in
                            AnnoncementView(annoncement: annoncement)
                        }
                    }
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle("Новости")
            .navigationBarTitleDisplayMode(.large)
            .onAppear(perform: {
                api.getNews { result in
                    guard let result = result else {
                        return
                    }
                    self.news = result
                }
                api.getAnnoncement { result in
                    guard let result = result else {
                        return
                    }
                    self.annoncements = result
                }
            })
        }
    }
}

struct NewsView: View {
    
    var news: News
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(news.name)
                .font(.system(size: 16, weight: .bold, design: .rounded))
            Text(news.content)
                .padding(.top, 5)
        }
        .foregroundColor(.primary)
        .padding(.vertical, 15)
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .background(.gray.opacity(0.2))
        .cornerRadius(8)
        .padding(.top, 10)
    }
}

struct AnnoncementView: View {
    
    var annoncement: Annoncement
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(annoncement.content)
        }
        .foregroundColor(.primary)
        .padding(.vertical, 15)
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .background(.gray.opacity(0.2))
        .cornerRadius(8)
        .padding(.top, 10)
    }
}

struct AnnoncementLink: Identifiable {
    var id = UUID()
    var url: URL
    var imageType: ImageType
    var image: String
    var name: String
}

enum ImageType {
    case system, network
}

struct AnnoncementLinkView: View {
    
    var link: AnnoncementLink
    
    var body: some View {
        Link(destination: link.url, label: {
            VStack {
                ZStack {
                    Circle()
                        .foregroundColor(Color.gray.opacity(0.2))
                    if link.imageType == .network {
                        AsyncImage(url: URL(string: link.image)!) { image in
                            image
                                .resizable()
                                .frame(width: 24, height: 24)
                        } placeholder: {
                            ProgressView()
                        }
                    } else if link.imageType == .system {
                        Image(systemName: link.image)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                .frame(width: 50, height: 50)
                Text(link.name)
                    .foregroundColor(.primary)
                    .font(.system(size: 10, weight: .regular, design: .default))
            }
        })
    }
}

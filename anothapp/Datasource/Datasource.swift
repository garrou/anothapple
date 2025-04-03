//
//  Datasoure.swift
//  anothapp
//
//  Created by Adrien Garrouste on 25/03/2025.
//

import Foundation

class Datasource {
    
    static var mockFriend = Friend(id: "12345", email: "test@mail.com", username: "Test", picture: nil, current: false)
    
    static var mockSeason = Season(number: 1, episodes: 82, image: "https://pictures.betaseries.com/fonds/seasons/3966/6673f65bbdf50.jpg", interval: "1 - 82")
    
    static var mockSerieInfos = SerieInfos(seasons: [], time: 0, episodes: 0)
    
    static var mockSerie = Serie(id: 33104, title: "Daredevil: Born Again", poster: "https://pictures.betaseries.com/fonds/poster/1b03b1f37e10c1eb8d675f869bc4adcd.jpg", kinds: ["Action", "Drame"], duration: 59, country: "États-Unis", seasons: 1, favorite: false, addedAt: Date(), watch: true)
    
    static var mockImages = ["https://picsum.photos/200", "https://picsum.photos/201", "https://picsum.photos/202"]
    
    static var mockDiscoverSerie = ApiSerie(id: 33104, title: "Daredevil: Born Again", poster: "https://pictures.betaseries.com/fonds/poster/1b03b1f37e10c1eb8d675f869bc4adcd.jpg", kinds: ["Action", "Drame"],  duration: 59, country: "États-Unis", synopsis: "Aveugle depuis ses neuf ans à la suite d'un accident, Matt Murdock bénéficie d'une acuité extraordinaire de ses autres sens. Avocat le jour, il devient le super-héros Daredevil lorsque la nuit tombe, afin de lutter contre l’injustice à New York, plus particulièrement dans le quartier de Hell's Kitchen, corrompu par la criminalité depuis sa reconstruction après l'attaque des Chitauris (lors des événements du film Avengers).", seasons: 1, episodes: 6, network: "Disney+", note: 4.37931, status: "En cours", creation: "2025", platforms: [Platform(id: 0, name: "Disney+", logo: "https://pictures.betaseries.com/platforms/246.jpg"), Platform(id: 0, name: "Canal+ Ciné Séries", logo: "https://pictures.betaseries.com/platforms/278.jpg")])
    
    static var mockEpisode = Episode(id: 472993, title: "eps1.0_hellofriend.mov", code: "S01E01", global: 1, description: "Elliot, ingénieur en cyber-sécurité le jour et hacker justicier la nuit, est recruté par un mystérieux groupe clandestin pour détruire l'entreprise qui l'a payé pour la protéger. Elliot doit décider jusqu'où il ira pour exposer les forces qui, pense-t-il, dirigent (et ruinent) le monde.", date: Date())
}

import Foundation

let mockSneaker: [Sneaker?] = [
  Sneaker(
    productID: "1",
    dtos: [
      SneakerDTO(
        id: "1",
        brand: "NIKE",
        colorway: "Sail/Muslin/Dark Mocha",
        estimatedMarketValue: 263,
        gender: "MEN",
        image: ImageDTO(
          the360: nil,
          original: "https://image.goat.com/attachments/product_template_pictures/images/098/212/826/original/1252833_00.png.png",
          small: "",
          thumbnail: "https://image.goat.com/375/attachments/product_template_pictures/images/098/212/826/original/1252833_00.png.png"
        ),
        links: LinksDTO(
          stockX: "",
          goat: "",
          flightClub: "",
          stadiumGoods: ""
        ),
        name: "Jordan Jumpman Jack TR Travis Scott Sail",
        releaseDate: "",
        releaseYear: "",
        retailPrice: 200,
        silhouette: "Jordan Jumpman Jack",
        sku: "",
        story: "The Jordan Jumpman Jack TR &#39;Sail&#39; delivers a neutral colorway of Travis Scott&#39;s debut signature shoe. Secured with a traditional lace closure and an adjustable midfoot strap, the upper features dark brown canvas construction with off-white leather overlays and a reverse beige Swoosh on the lateral side. Contrasting crimson accents land on the Jumpman icon atop the tongue and the Cactus Jack face logo stamped on the back heel. A grippy gum rubber outsole with a wear-away &quot;Jack&quot; wordmark wraps up the sidewalls of the white foam midsole."
      )
    ]
  )
]

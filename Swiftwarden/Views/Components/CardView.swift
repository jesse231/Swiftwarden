import SwiftUI

struct CardView: View {
    @State var showNumber = false
    @State var showCode = false
    var card: Card
    var body: some View {
        Field(
            title: "Cardholder Name",
            content: card.cardHolderName ?? "",
            buttons: {
                Copy(content: card.cardHolderName ?? "")
            })

        Field(
            title: "Number",
            content: (showNumber ? card.number ?? "" : String(repeating: "•", count: card.number?.count ?? 0)),
            buttons: {
                Hide(toggle: $showNumber)
                Copy(content: card.number ?? "")
            })

        Field(
            title: "Brand",
            content: card.brand ?? "",
            buttons: {
            })

        Field(
            title: "Expiration",
            content: card.expMonth ?? "" + "/" + (card.expYear ?? ""),
            buttons: {
            })

        Field(
            title: "Code",
            content: (showCode ? card.code ?? "" : String(repeating: "•", count: card.code?.count ?? 0)),
            buttons: {
                Hide(toggle: $showCode)
                Copy(content: card.code ?? "")
            })
    }
}

// struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
// }

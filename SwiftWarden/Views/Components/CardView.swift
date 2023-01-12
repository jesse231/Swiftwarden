import SwiftUI

struct CardView: View {
    @State var showNumber = false
    @State var showCode = false
    var card: Card
    var body: some View {
        Field(
            title: "Cardholder Name",
            content: card.CardholderName ?? "",
            buttons: {
                Copy(content: card.CardholderName ?? "")
            })
        
        Field(
            title: "Number",
            content: (showNumber ? card.Number ?? "" : String(repeating: "•", count: card.Number?.count ?? 0)),
            buttons: {
                Hide(toggle: $showNumber)
                Copy(content: card.Number ?? "")
            })
        
        Field(
            title: "Brand",
            content: card.Brand ?? "",
            buttons: {
            })
        
        Field(
            title: "Expiration",
            content: card.ExpMonth ?? "" + "/" + (card.ExpYear ?? ""),
            buttons: {
            })
        
        
        Field(
            title: "Code",
            content: (showCode ? card.Code ?? "" : String(repeating: "•", count: card.Code?.count ?? 0)),
            buttons: {
                Hide(toggle: $showCode)
                Copy(content: card.Code ?? "")
            })
    }
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
//}

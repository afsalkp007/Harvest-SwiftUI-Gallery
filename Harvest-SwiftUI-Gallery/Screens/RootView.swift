import SwiftUI
import HarvestStore

struct RootView: View
{
    private let store: Store<Root.Input, Root.State>.Proxy

    init(store: Store<Root.Input, Root.State>.Proxy)
    {
        self.store = store
    }

    var body: some View
    {
        return VStack {

            NavigationView {
                List(allExamples, id: \.exampleTitle) { example in
                    NavigationLink(
                        destination: example.exampleView(store: self.store)
                            .frame(minWidth: 600, maxWidth: 600, minHeight: 300, maxHeight: .infinity),
//                            .navigationBarTitle("\(example.exampleTitle)", displayMode: .inline),
                        isActive: self.store.current
                            .stateBinding(onChange: Root.Input.changeCurrent)
                            .transform(
                                get: { $0?.example.exampleTitle == example.exampleTitle },
                                set: { _, isPresenting in
                                    isPresenting ? example.exampleInitialState : nil
                                }
                            )
                    ) {
                        HStack(alignment: .firstTextBaseline) {
                            example.exampleIcon
                                .frame(width: 44)
                            Text(example.exampleTitle)
                        }
                        .font(.body)
                        .padding(5)
                    }
                }
                .frame(minWidth: 300, maxWidth: 300, minHeight: 300, maxHeight: .infinity)
//                .navigationBarTitle(Text("🌾 Harvest Gallery 🖼️"), displayMode: .large)
            }

//            Divider()
//
//            Toggle(isOn: store.$state.isDebug) {
//                Text("Debug Mode")
//            }
//            .padding(.horizontal)
        }
    }
}

struct RootView_Previews: PreviewProvider
{
    static var previews: some View
    {
        return Group {
            RootView(
                store: .init(
                    state: .constant(Root.State()),
                    send: { _ in }
                )
            )
                .previewLayout(.fixed(width: 320, height: 480))
                .previewDisplayName("Root")

            RootView(
                store: .init(
                    state: .constant(Root.State(current: .intro)),
                    send: { _ in }
                )
            )
                .previewLayout(.fixed(width: 320, height: 480))
                .previewDisplayName("Intro")
        }
    }
}

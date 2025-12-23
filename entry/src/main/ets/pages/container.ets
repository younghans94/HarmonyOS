import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct Container {
  private controller: webview.WebviewController =
    new webview.WebviewController()

  build() {
    Column() {
      Web({
        src: 'http://example.com',
        controller: this.controller
      })
        .width(300)
        .height(500)
    }
    .width(400)
    .height(600)
    .backgroundColor(Color.Gray)
  }
}

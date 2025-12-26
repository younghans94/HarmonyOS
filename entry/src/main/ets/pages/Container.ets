import { webview } from '@kit.ArkWeb';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct Container {
  private controller: webview.WebviewController =
    new webview.WebviewController()
  ports: webview.WebMessagePort[] = [];

  aboutToAppear(): void {
  }

  aboutToReuse(params: Record<string, Object | null | undefined>): void {

  }

  aboutToDisappear(): void {

  }

  aboutToRecycle(): void {

  }
  onPageShow(): void {

  }

  onPageHide(): void {

  }


  build() {
    Column() {
      Button('Reload')
        .margin(10)
        .onClick(() => {
          try {
            this.controller.refresh();
          } catch (error) {
            // TODO: Implement error handling.
          }
        })
      Web({
        // src: 'http://192.168.5.7:8075/webroot/decision',
        src: $rawfile("index.html"),
        controller: this.controller
      })
        .onPageEnd(() => {
          try {
            // 1、创建两个消息端口。
            this.ports = this.controller.createWebMessagePorts();
            // 2、在应用侧的消息端口(如端口1)上注册回调事件。
            this.ports[1].onMessageEvent((result: webview.WebMessage) => {
              let msg = 'Got msg from HTML:';
              if (typeof (result) == "string") {
                console.info("received string message from html5, string is:" + result);
                msg = msg + result;
              } else if (typeof (result) == "object") {
                if (result instanceof ArrayBuffer) {
                  console.info("received arraybuffer from html5, length is:" + result.byteLength);
                  msg = msg + "length is " + result.byteLength;
                } else {
                  console.info("not support");
                }
              } else {
                console.info("not support");
              }
            })
            // 3、将另一个消息端口(如端口0)发送到HTML侧，由HTML侧保存并使用。
            this.controller.postMessage('__init_port__', [this.ports[0]], '*');
          } catch (error) {
            console.error(`ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
          }
        })
        .width("100%")
        .height("100%")
    }
    .width("100%")
    .height("100%")
  }
}

import { webview } from '@kit.ArkWeb';
import { camera, cameraPicker } from '@kit.CameraKit';
import { abilityAccessCtrl, common } from '@kit.AbilityKit';

@Entry
@Component
struct Container {
  private controller: webview.WebviewController =
    new webview.WebviewController()
  ports: webview.WebMessagePort[] = [];
  uiContext: UIContext = this.getUIContext();

  aboutToAppear(): void {
    webview.WebviewController.setWebDebuggingAccess(true);
    let atManager = abilityAccessCtrl.createAtManager();
    atManager.requestPermissionsFromUser(this.uiContext.getHostContext(),
      ['ohos.permission.CAMERA', 'ohos.permission.MICROPHONE'])
      .then((data) => {
        console.info(`data:${data}`);
        console.info(`data permissions:${data.permissions}`);
        console.info(`data authResults:${data.authResults}`);
      }).catch((error: BusinessError) => {
      console.error(`Failed to request permissions from user. Code is ${error.code}, message is ${error.message}`);
    });
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
        .onShowFileSelector((event) => {
          openCamera((uri: string) => {
            event.result.handleFileList([uri]); // 返回相机拍摄结果
          }, this.getUIContext());
          return true; // 拦截默认行为
        })
        .onPermissionRequest((event) => {
          if (event) {
            this.uiContext.showAlertDialog({
              title: 'title',
              message: 'text',
              primaryButton: {
                value: 'deny',
                action: () => {
                  event.request.deny();
                }
              },
              secondaryButton: {
                value: 'onConfirm',
                action: () => {
                  event.request.grant(event.request.getAccessibleResource());
                }
              },
              cancel: () => {
                event.request.deny();
              }
            });
          }
        })
        .width("100%")
        .height("100%")
    }
    .width("100%")
    .height("100%")
  }
}

async function openCamera(callback: Callback<string>, uiContext: UIContext) {
  let mContext = uiContext.getHostContext() as common.Context;
  try {
    let pickerProfile: cameraPicker.PickerProfile = {
      cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
    };
    let pickerResult: cameraPicker.PickerResult = await cameraPicker.pick(mContext,
      [cameraPicker.PickerMediaType.PHOTO, cameraPicker.PickerMediaType.VIDEO], pickerProfile);
    callback(pickerResult.resultUri);
  } catch (error) {
    let err = error as BusinessError;
    console.error(`the pick call failed. error code: ${err.code}`);
  }
}

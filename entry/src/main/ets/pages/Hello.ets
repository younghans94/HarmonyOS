@Entry
@Component

struct Hello {
  @State message: string = 'Hello World';
  @State wrap: FlexWrap = FlexWrap.NoWrap

  build() {
    // 使用 Column 作为根容器，Flex 容器
    Flex({ wrap: this.wrap })
    {
      Button("switch wrap")
        .onClick(() => {
          this.wrap = FlexWrap.Wrap
        })
        .flexGrow(1)
        .flexShrink(0)
        .flexBasis(0)
      Text(this.message)
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .background('red')
        .padding({ top: 10, bottom: 10, left: 20, right: 20 })
        .flexGrow(1)
        .flexShrink(0)
        .flexBasis(0)
      Text(this.message)
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .background('red')
        .padding({ top: 10, bottom: 10, left: 20, right: 20 })
        .flexGrow(1)
        .flexShrink(0)
        .flexBasis(0)
    }
    .height('100%')
    .width('100%')
    .background('green')
  }
}
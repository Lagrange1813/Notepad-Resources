### Common Text View

viewDidLoad

- loadData() 
  - 取得 text 序列
- loadInfo() 
  - 取得 text 类型
  - 加载当前 text

viewWillAppear() 

- loadTextView
  - 根据相应类型生成对应 textField
- configureTextView()
  - textField 布局
  - 加载文字
- Optional configureCounter()

viewDidAppear() 

- textField.resize() 
  - 重新计算 scrollView contentSize

viewWillLayoutSubviews

- textField.correctLayout()
  - 根据视图宽度重新计算 titleView, bodyView 宽度

viewDidLayoutSubviews

- adjustView()
  - 重新计算 scrollView contentSize

viewWillTransition

- textField.correctLayou()
  - 根据视图宽度重新计算 titleView, bodyView 宽度
- adjustView()
  - 重新计算 scrollView contentSize

---

### Compact Text View

viewDidLoad

- loadData() 
  - 取得 text 序列
- loadInfo() 
  - 取得 text 类型
  - 加载当前 text
- preload()
  - 根据UD加载纯文字主题
  - 根据UD加载MD主题

- loadTheme()
  - 根据类型加载对应主题

- customize()
  - 客制化视图方向，状态栏行为
  - Optional 加载毛玻璃背景
  - updateViewWidth() 
    - 重制宽度

  - 客制化 Padding 等


viewWillAppear() 

- loadTextView
  - 根据相应类型生成对应 textField
- configureTextView()
  - textField 布局
  - 加载文字
- Optional configureCounter()
- configureToolBar()
  - 根据 viewWidth 配置ToolBar

- configureTitleBar()
  - 根据 viewWidth 配置TitleBar

- registNotification()
  - 注册键盘通知
    - KeyBoardWillShow
    - KeyBoardWillHide

- configureTitleBarBtnAction()
- configureToolBarBtnAction()

viewDidAppear() 

- textField.resize() 
  - 重新计算 scrollView contentSize
- updateUnRedoButtons()

viewWillLayoutSubviews

- textField.correctLayout()
  - 根据视图宽度重新计算 titleView, bodyView 宽度
- updateViewWidth()
- updateComponents()
  - 更新双栏宽度


viewDidLayoutSubviews

- adjustView()
  - 重新计算 scrollView contentSize

viewWillTransition

- textField.correctLayout()
  - 根据视图宽度重新计算 titleView, bodyView 宽度
- adjustView()
  - 重新计算 scrollView contentSize
